public class ScatterPlot extends Chart {
  private final int NUM_GAPS = 5;
  private final int TEXT_SIZE = 10;
  private final float PT_RADIUS = 4;
  private final int MAX_VALUE = 5;
  
  private String title;
  
  // theme: limes
  public ScatterPlot(Data data, int chartX, int chartY, int chartWidth, int chartHeight){
    super(data, chartX, chartY, chartWidth, chartHeight);
    this.name = "ScatterPlot";
    this.title = "Limes";
    this.xhead = "Time Since Purchase (days)";
    this.yhead = "Sourness rating";
  }
  
  private float getChartX() {
    textSize(TEXT_SIZE);
    return getX() + textAscent() + textDescent() + textWidth(String.valueOf(0)) + 15;
  }
  
  private float getChartY() {
    textSize(TEXT_SIZE * 2);
    return getY() + textAscent() + textDescent() + 20;
  }
  
  private float getChartWidth() {
    return getX() + getWidth() - getChartX() - 10;
  }
  
  private float getChartHeight() {
    textSize(TEXT_SIZE * 2);
    float titleH = textAscent() + textDescent() + 20;
    textSize(TEXT_SIZE);
    float restH = textAscent() + textDescent();
    return getHeight() - titleH - 2 * restH - 20;
  }
  
  protected color getPointColor() {
    color themed = color(50, 205, 50);
    switch (COLOR_MODE) {
      case THEMED:
        return themed;
      case OPPOSITE:
        return color(255-red(themed), 255-green(themed), 255-blue(themed));
      default:
        return 255;
    }
  }
  
  protected float scaleValue(float trueValue) {
    return trueValue * MAX_VALUE;
  }
  
  public void draw() {
    float x = getX(), y = getY(), w = getWidth(), h = getHeight();
    float chartX = getChartX(), chartY = getChartY();
    float chartW = getChartWidth(), chartH = getChartHeight();
    textAlign(CENTER, CENTER);
    
    // bg
    //noStroke();
    //fill(255);
    //rect(x, y, w, h);
    
    // title
    strokeWeight(1);
    textSize(TEXT_SIZE * 2);
    fill(0);
    text(this.title, x + w/2, y + (textAscent() + textDescent())/2);
    
    // headers
    fill(0);
    textSize(TEXT_SIZE);
    text(this.xhead, chartX + chartW/2, getY() + getHeight() - textAscent() - textDescent());
    pushMatrix();
    translate(getX() + textAscent() + textDescent() - 5, chartY + chartH/2);
    rotate(radians(-90));
    text(this.yhead, 0, 0);
    popMatrix();
    
    // x ticks and points
    textSize(TEXT_SIZE);
    stroke(0);
    int xgaps = this.data.size() + 1;
    color ptColor = getPointColor();
    for (int i = 1; i < xgaps; i++) {
      String tickStr = String.valueOf((i - 1) * 3);
      float tickX = chartX + i * chartW / xgaps;
      
      // tick
      fill(0);
      line(tickX, chartY + chartH, tickX, chartY + chartH + 5);
      text(tickStr, tickX, chartY + chartH + 15);
      
      // point
      fill(ptColor);
      float value = this.data.get(i - 1).getValue();
      float ptY = chartY + chartH * (1 - value);
      ellipse(tickX, ptY, PT_RADIUS*2, PT_RADIUS*2);
      
      // point label
      fill(0);
      text(getCharForNumber(i), tickX + PT_RADIUS + 5, ptY - PT_RADIUS - 5);
    }
    
    // y ticks
    textSize(TEXT_SIZE);
    stroke(0);
    fill(0);
    int ygaps = NUM_GAPS;
    for (int i = 0; i < ygaps + 1; i++) {
      String tickStr = String.valueOf(ygaps - i);
      float tickY = chartY + i * chartH / ygaps;
      line(chartX, tickY, chartX - 5, tickY);
      text(tickStr, chartX - textWidth(tickStr) - 5, tickY);
    }
    
    // axis lines
    stroke(0);
    line(chartX, chartY + chartH, chartX + chartW, chartY + chartH); // x axis
    line(chartX, chartY, chartX, chartY + chartH); // y axis
  }
}