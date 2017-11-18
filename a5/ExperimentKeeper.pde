public class ExperimentKeeper{

  private static final String FNAME_PREFIX       = "results/";
  private static final int NUMBER_OF_TRIALS      = 3;
  private static final int NUMBER_OF_DATA_POINTS = 5;

  private static final int STATE_PROLOGUE = 0;
  private static final int STATE_TRIAL    = 1;
  private static final int STATE_RECALL   = 2;
  private static final int STATE_EPILOGUE = 3;
  
  private static final int TIME_PER_TRIAL = 10000; // 10 seconds, 10000 millis
  //private static final int TIME_PER_TRIAL = 1000; // 10 seconds, 10000 millis

  private Canvas canvas;
  private String participantID;
  private int totalTrials;
  private int currentTrialIndex;
  private Chart[] charts;
  private Chart chart;
  private String[] answers;
  private int enabledAnswer;
  private Table result;
  private int state;
  private int startTime;

  public ExperimentKeeper(int canvasX, int canvasY, int canvasWidth, int canvasHeight){
    this.canvas = new Canvas(canvasX, canvasY, canvasWidth, canvasHeight, NUMBER_OF_DATA_POINTS);
    this.participantID = "p" + getTime();
    this.totalTrials = NUMBER_OF_TRIALS;
    this.currentTrialIndex = 0;
    int numberOfDataPointsPerTrial = NUMBER_OF_DATA_POINTS;

    int chartSize = 300;
    int chartX = this.canvas.getCenterX() - chartSize / 2;
    int chartY = this.canvas.getY() + 100;

    Data[] dataset = this.generateDatasetBy(this.totalTrials, numberOfDataPointsPerTrial);
    this.charts = this.generateChartsFor(dataset, chartX, chartY, chartSize, chartSize);

    this.chart = null;
    this.answers = new String[NUMBER_OF_DATA_POINTS];
    this.enabledAnswer = 0;
    clearAnswers();
    this.result = this.createResultTable();
    this.state = STATE_PROLOGUE;
    this.startTime = -1;
  }
  
  // for unique id
  private String getTime() {
    return String.format("%d-%d-%d.%d-%d-%d", year(), month(), day(), hour(), minute(), second());
  }

  public Data[] generateDatasetBy(int numberOfTrials, int numberOfDataPointPerTrial){
    Data[] dataset = new Data[numberOfTrials];

    //ToDo: decide how to generate the dataset you will be using (See also Data.pde)
    //      Note that the "dataset" holds all data that will be used in one experiment

    return dataset;
  }

  public Chart[] generateChartsFor(Data[] dataset, int chartX, int chartY, int chartWidth, int chartHeight){
    Chart[] charts = new Chart[dataset.length];

    //ToDo: decide how to generate your visualization for each data (See also Chart.pde and SampleChart.pde)
    //      Note that each data holds all datapoints that will be projected in one chart
    for(int i = 0; i < dataset.length; i++)
      charts[i] = new SampleChart(new Data(0), chartX, chartY, chartWidth, chartHeight);

    return charts;
  }

  public void draw(){
    this.canvas.draw();
    if(this.state == STATE_PROLOGUE)
      this.canvas.drawIntroduction();
    else if(this.state == STATE_TRIAL) {
      if (this.startTime < 0) this.startTime = millis(); // start timer as late as possible
      int timeElapsed = millis() - this.startTime; 
      this.canvas.drawTrialWith(
        this.chart,
        (TIME_PER_TRIAL - timeElapsed) / 1000,
        this.currentTrialIndex + 1, 
        this.totalTrials
      );
      if (timeElapsed >= TIME_PER_TRIAL) this.state = STATE_RECALL;
    } else if (this.state == STATE_RECALL) {
      this.canvas.drawRecallWith(
        this.answers,
        this.currentTrialIndex + 1,
        this.totalTrials
      );
    } else if(this.state == STATE_EPILOGUE)
      this.canvas.drawClosingMessage();
  }

  private Table createResultTable(){
    Table table = new Table();
    table.addColumn("PartipantID");
    table.addColumn("TrialIndex");
    table.addColumn("ChartName");
    table.addColumn("DataPointIndex");
    table.addColumn("TrueValue");
    table.addColumn("RecalledValue");
    table.addColumn("Error");
    return table;
  }
  
  private void clearAnswers() {
    for (int i = 0; i < this.answers.length; i++) {
      this.answers[i] = "";
    }
  }
  
  private void recordTrial() {
    Data data = this.chart.getData();
    
    for (int i = 0; i < this.answers.length; i++) {
      float trueValue = data.get(i).getValue();
      float recalledValue = Float.valueOf(this.answers[i]);
      float error = log(abs(recalledValue - trueValue) + 1f / 8f) / log(2);
      //float truePercentage = 0.0;     //ToDo: decide how to compute the right answer
      //float reportedPercentage = 0.0; //ToDo: Note that "this.answer" contains what the participant inputed
      //float error = 0.0;              //ToDo: decide how to compute the log error from Cleveland and McGill (see the handout for details)
  
      TableRow row = this.result.addRow();
      row.setString("PartipantID", this.participantID);
      row.setInt("TrialIndex", this.currentTrialIndex);
      row.setString("ChartName", this.chart.getName());
      row.setInt("DataPointIndex", i);
      row.setFloat("TrueValue", trueValue);
      row.setFloat("RecalledValue", recalledValue);
      row.setFloat("Error", error);
    }
  }
  
  private void toNextTrial() {
    this.currentTrialIndex++;
    if (this.currentTrialIndex < this.totalTrials) {
      this.chart = this.charts[this.currentTrialIndex];
      clearAnswers();
      this.state = STATE_TRIAL;
      this.startTime = -1;
    } else {
      this.state = STATE_EPILOGUE;
    }
  }

  public void onMouseClickedAt(int x, int y){
    //println("X:" + x + ", Y:" + y);
    if(this.canvas.contain(x, y)){
      switch(this.state){
        case STATE_PROLOGUE:
          if(this.canvas.hasActiveAgreeButtonAt(x, y)){
            this.chart = this.charts[this.currentTrialIndex];
            clearAnswers();
            this.state = STATE_TRIAL;
          }else if(this.canvas.hasActiveDisagreeButtonAt(x, y)){
            exit();
          }
          break;

        case STATE_TRIAL:
          break;
          
        case STATE_RECALL:
          int textFieldIndex = this.canvas.hasTextFieldAt(x, y);
          if (textFieldIndex >= 0) {
            this.canvas.enableTextField(textFieldIndex);
            this.enabledAnswer = textFieldIndex;
          }
          
          if (this.canvas.hasActiveNextButtonAt(x, y)) {
            recordTrial();          
            toNextTrial();
          }
          
          break;

        case STATE_EPILOGUE:
          if(this.canvas.hasActiveCloseButtonAt(x, y)){
            saveTable(this.result, FNAME_PREFIX + this.participantID + ".csv", "csv");
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
    String answer = this.answers[this.enabledAnswer];
    if(this.state == STATE_RECALL){
      if (keyTyped == 46 || (48 <= keyTyped && keyTyped <= 57)) { //period or between 0-9
        if(answer.length() < 10) //limit # charcters to be 10
          this.answers[this.enabledAnswer] += char(keyTyped);
      } else if (keyTyped == 8 || keyTyped == 127) { //backspace, delete
        if(answer.length() > 0)
          this.answers[this.enabledAnswer] = answer.substring(0, answer.length() - 1);
      } else if (keyTyped == 9) {
        this.enabledAnswer = (this.enabledAnswer + 1) % this.answers.length;
        this.canvas.enableTextField(this.enabledAnswer);
      }
      for (String ans : this.answers) {
        if (Float.isNaN(float(ans)) || ans.length() == 0) {
          this.canvas.disableNextButton();
          return;
        }
      }
      this.canvas.enableNextButton();
      if (keyTyped == ENTER) { // next button is guaranteed to be active
        recordTrial();          
        toNextTrial();
      }
    }
  }

}