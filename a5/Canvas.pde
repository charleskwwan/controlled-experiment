public class Canvas extends Viewport{
  final int buttonWidth = 70;
  final int buttonHeight = 34;
  final int textFieldWidth = 200;
  final int textFieldHeight = 34;
  
  private Button agreeButton;
  private Button disagreeButton;
  private TextField[] answerTextFields;
  private Button nextButton;
  private Button closeButton;

  public Canvas(int canvasX, int canvasY, int canvasWidth, int canvasHeight, int numberOfDataPoints){
    super(canvasX, canvasY, canvasWidth, canvasHeight);
    
    this.agreeButton = new Button("AGREE", true, this.viewCenterX + 50, this.viewCenterY + 160, buttonWidth, buttonHeight);
    this.disagreeButton = new Button("DISAGREE", true, this.viewCenterX - 50 - buttonWidth, this.viewCenterY + 160, buttonWidth, buttonHeight);
    this.nextButton = new Button("NEXT", false, this.viewCenterX - buttonWidth/2, this.viewCenterY + 200, buttonWidth, buttonHeight);
    this.closeButton = new Button("CLOSE", true, this.viewCenterX - (buttonWidth / 2), this.viewCenterY + 100, buttonWidth, buttonHeight);
    
    //this.answerTextField = new TextField(this.viewCenterX - 140, this.viewCenterY + 200, textFieldWidth, textFieldHeight);
    this.answerTextFields = new TextField[numberOfDataPoints];
    int y = this.getY() + this.getHeight() / 6;
    for (int i = 0; i < numberOfDataPoints; i++) {
      this.answerTextFields[i] = new TextField(
        this.viewCenterX - 50,
        y,
        textFieldWidth,
        textFieldHeight
      );
      y += textFieldHeight + 10;
    }
    this.answerTextFields[0].enable();
  }

  @Override
  public void draw(){
    noStroke();
    fill(230);
    rect(this.viewX, this.viewY, this.viewWidth, this.viewHeight);
  }

  public void drawIntroduction(){
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("In this experiment,\n" +
         "you will be shown a series of charts and\n" +
         "be given 10 seconds to remember the data.\n" +
         "You will then be asked to recall the data on\n" +
         "the subsequent screen.\n\n" +
         "We won't record any other information from you except your answers.\n" +
         "Click the \"agree\" button to begin.",
         this.viewCenterX, this.viewCenterY);
    this.disagreeButton.draw();
    this.agreeButton.draw();
  }

  public void drawTrialWith(Chart chart, int timeLeft, int trialNumber, int totalTrials){
    chart.draw();
    int y = chart.getY() + chart.getHeight() + 30;
    fill(0);
    textSize(20);
    textAlign(RIGHT, TOP);
    text("(" + trialNumber + "/" + totalTrials + ")", this.viewX + this.viewWidth, this.viewY);
    textSize(16);
    textAlign(CENTER);
    text("Please remember the data in the chart above.\n" +
         "Time remaining:\n",
         this.viewCenterX, y);
    textSize(30);
    text(String.valueOf(timeLeft + 1) + " seconds",
         this.viewCenterX, y + 75);
  }
  
  public void drawRecallWith(String[] answers, int trialNumber, int totalTrials) {
    fill(0);
    textSize(20);
    textAlign(RIGHT, TOP);
    text("(" + trialNumber + "/" + totalTrials + ")", this.viewX + this.viewWidth, this.viewY);
    
    for (int i = 0; i < answers.length; i++) {
      TextField field = this.answerTextFields[i];
      String ptLabel = "Data Point " + String.valueOf(i) + ": ";
      fill(0);
      textSize(16);
      textAlign(LEFT, TOP);
      text(ptLabel, field.getX() - textWidth(ptLabel) - 10, field.getY() + 5);
      field.draw(answers[i]);
    }
    
    this.nextButton.draw();
  }

  public void drawClosingMessage(){
    fill(0);
    textSize(60);
    textAlign(CENTER, CENTER);
    text("Thanks!", this.viewCenterX, this.viewCenterY);
    this.closeButton.draw();
  }
  
  public void enableTextField(int i) {
    for (int j = 0; j < this.answerTextFields.length; j++) {
      if (i == j)
        this.answerTextFields[j].enable();
      else
        this.answerTextFields[j].disable();
    }
  }

  public void enableNextButton(){
    this.nextButton.enable();
  }

  public void disableNextButton(){
    this.nextButton.disable();
  }
  
  public int hasTextFieldAt(int x, int y) {
    for (int i = 0; i < this.answerTextFields.length; i++) {
      if (this.answerTextFields[i].contain(x, y)) return i;
    }
    return -1;
  }

  public boolean hasActiveAgreeButtonAt(int x, int y){
    if(this.agreeButton.isEnabled() && this.agreeButton.contain(x, y))
      return true;
    else
      return false;
  }

  public boolean hasActiveDisagreeButtonAt(int x, int y){
    if(this.disagreeButton.isEnabled() && this.disagreeButton.contain(x, y))
      return true;
    else
      return false;
  }

  public boolean hasActiveNextButtonAt(int x, int y){
    if(this.nextButton.isEnabled() && this.nextButton.contain(x, y))
      return true;
    else
      return false;
  }

  public boolean hasActiveCloseButtonAt(int x, int y){
    if(this.closeButton.isEnabled() && this.closeButton.contain(x, y))
      return true;
    else
      return false;
  }

}