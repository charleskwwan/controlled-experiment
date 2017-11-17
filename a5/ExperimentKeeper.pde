public class ExperimentKeeper{

  private static final String PARTICIPANT_ID     = "p1"; 
  private static final int NUMBER_OF_TRIALS      = 5;    
  private static final int NUMBER_OF_DATA_POINTS = 10;   

  private static final int STATE_PROLOGUE = 0;
  private static final int STATE_TRIAL    = 1;
  private static final int STATE_RECALL   = 3;
  private static final int STATE_EPILOGUE = 2;

  private Canvas canvas;
  private String participantID;
  private int totalTrials;
  private int currentTrialIndex;
  private Chart[] charts;
  private Chart chart;
  private String answer;
  private Table result;
  private int state;

  public ExperimentKeeper(int canvasX, int canvasY, int canvasWidth, int canvasHeight){
    this.canvas = new Canvas(canvasX, canvasY, canvasWidth, canvasHeight);
    this.participantID = PARTICIPANT_ID;
    this.totalTrials = NUMBER_OF_TRIALS;
    this.currentTrialIndex = 0;
    int numberOfDataPointsPerTrial = NUMBER_OF_DATA_POINTS;

    int chartSize = 300;
    int chartX = this.canvas.getCenterX() - chartSize / 2;
    int chartY = this.canvas.getY() + 100;

    Data[] dataset = this.generateDatasetBy(this.totalTrials, numberOfDataPointsPerTrial);
    this.charts = this.generateChartsFor(dataset, chartX, chartY, chartSize, chartSize);

    this.chart = null;
    this.answer = "";
    this.result = this.createResultTable();
    this.state = STATE_PROLOGUE;
  }

  private Data[] generateDatasetBy(int numberOfTrials, int numberOfDataPointPerTrial){
    Data[] dataset = new Data[numberOfTrials];
    
    for(int i = 0; i < numberOfTrials; i++) {
      dataset[i] = new Data(numberOfDataPointPerTrial);
    }
    
    return dataset;
  }

  private Chart[] generateChartsFor(Data[] dataset, int chartX, int chartY, int chartWidth, int chartHeight){
    Chart[] charts = new Chart[dataset.length];
    
    for(int i = 0; i < dataset.length; i++) {
      charts[i] = new RadarChart(new Data(NUMBER_OF_DATA_POINTS), chartX, chartY, chartWidth, chartHeight, new String[]{"a", "b", "c", "d", "e", "f"});
      //if (int(random(2)) == 1) {
      //  charts[i] = new BarChart(new Data(NUMBER_OF_DATA_POINTS), chartX, chartY, chartWidth, chartHeight);
      //} else {
      //  charts[i] = new PieChart(new Data(NUMBER_OF_DATA_POINTS), chartX, chartY, chartWidth, chartHeight);
      //}
    }

    return charts;
  }

  public void draw(){
    this.canvas.draw();
    if(this.state == STATE_PROLOGUE)
      this.canvas.drawIntroduction();
    else if(this.state == STATE_TRIAL)
      this.canvas.drawTrialWith(this.chart, this.answer, this.currentTrialIndex + 1, this.totalTrials);
    else if(this.state == STATE_EPILOGUE)
      this.canvas.drawClosingMessage();
  }

  private Table createResultTable(){
    Table table = new Table();
    table.addColumn("PartipantID");
    table.addColumn("TrialIndex");
    table.addColumn("ChartName");
    table.addColumn("TruePercentage");
    table.addColumn("ReportedPercentage");
    table.addColumn("Error");
    return table;
  }
  
  //private float getTruePercentage() {
  //  //ArrayList<Data.DataPoint> markedPoints = this.charts[currentTrialIndex].data.getMarkedPoints();
  //  float minValue = min(markedPoints.get(0).getValue(), markedPoints.get(1).getValue());
  //  float maxValue = max(markedPoints.get(0).getValue(), markedPoints.get(1).getValue());
  //  return minValue / maxValue * 100;
  //}
  
  private float log(float x, float base)
  {
      return (float)(Math.log(x) / Math.log(base));
  }
  
  private float getError(float truePercentage, float reportedPercentage){
    return log(abs(truePercentage - reportedPercentage) + .125, 2);
  }

  public void onMouseClickedAt(int x, int y){
    //println("X:" + x + ", Y:" + y);
    if(this.canvas.contain(x, y)){
      switch(this.state){
        case STATE_PROLOGUE:
          if(this.canvas.hasActiveAgreeButtonAt(x, y)){
            this.chart = this.charts[this.currentTrialIndex];
            this.answer = "";
            this.state = STATE_TRIAL;
          }else if(this.canvas.hasActiveDisagreeButtonAt(x, y)){
            exit();
          }
          break;

        case STATE_TRIAL:
          if(this.canvas.hasActiveNextButtonAt(x, y)){

            Data data = this.chart.getData();

            //float truePercentage = getTruePercentage();
            //float reportedPercentage = Float.valueOf(this.answer);
            //float error = getError(truePercentage, reportedPercentage);
            float truePercentage = 0.0;     //ToDo: decide how to compute the right answer
            float reportedPercentage = 0.0; //ToDo: Note that "this.answer" contains what the participant inputed
            float error = 0.0;              //ToDo: decide how to compute the log error from Cleveland and McGill (see the handout for details

            TableRow row = this.result.addRow();
            row.setString("PartipantID", this.participantID);
            row.setInt("TrialIndex", this.currentTrialIndex);
            row.setString("ChartName", this.chart.getName());
            row.setFloat("TruePercentage", truePercentage);
            row.setFloat("ReportedPercentage", reportedPercentage);
            row.setFloat("Error", error);

            ++this.currentTrialIndex;
            if(this.currentTrialIndex < this.totalTrials){
              this.chart = this.charts[this.currentTrialIndex];
              this.answer = "";
            }else{
              this.state = STATE_EPILOGUE;
            }
          }
          break;

        case STATE_EPILOGUE:
          if(this.canvas.hasActiveCloseButtonAt(x, y)){
            saveTable(this.result, this.participantID + ".csv", "csv");
            exit();
          }
          break;

        default:
          break;
      }
    }
  }

  public void onKeyTyped(int keyTyped){
    //println(int(keyTyped) + ":" + char(keyTyped));
    if(this.state == STATE_TRIAL){
      if(keyTyped == 46 || (48 <= keyTyped && keyTyped <= 57)){ //period or between 0-9
        if(this.answer.length() < 10){ //limit # charcters to be 10
          this.answer += char(keyTyped);
          if(!Float.isNaN(float(this.answer)))
            this.canvas.enableNextButton();
          else
            this.canvas.disableNextButton();
        }
      }else if(keyTyped == 8 || keyTyped == 127){ //backspace, delete
        if(this.answer.length() > 0){
          this.answer = this.answer.substring(0, this.answer.length() - 1);
          if(!Float.isNaN(float(this.answer)) && this.answer.length() > 0)
            this.canvas.enableNextButton();
          else
            this.canvas.disableNextButton();
        }
      }
    }
  }

}