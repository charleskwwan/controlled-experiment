public class BarChart extends Chart {
  private final int NUM_GAPS = 5;
  private final int TEXT_SIZE = 10;
  private final int BAR_WIDTH = 25;
  private final int MAX_VALUE = 100;
  private String title;
  private String[] xlabels;

  // theme: love 
  public BarChart(Data data, int chartX, int chartY, int chartWidth, int chartHeight){
    super(data, chartX, chartY, chartWidth, chartHeight);
    this.name = "BarChart";
    this.title = "Love";
    this.xhead = "Duration of Relationship (Years)";
    this.yhead = "Rating (Percentage)";
    this.xlabels = new String[] {"1", "2", "3", "4", "5+"};
  }
  
  @Override
  void draw() {
    float x = getX(), y = getY(), w = getWidth(), h = getHeight();
    float chartX = getChartX(), chartY = getChartY();
    float chartW = getChartWidth(), chartH = getChartHeight();
    
    // bg
    //noStroke();
    //fill(255);
    //rect(x, y, w, h);
    
    stroke(0);
    strokeWeight(1);
    fill(255);
    fill(0);
    color dataColor = getPointColor();    
    
    // title
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
    for (int i = 1; i < xgaps; i++) {
      float tickX = chartX + i * chartW / xgaps;
      
      // tick
      fill(0);
      line(tickX, chartY + chartH, tickX, chartY + chartH + 5);
      text(xlabels[i - 1], tickX, chartY + chartH + 15);

      // bar
      fill(dataColor);
      float rectHeight = chartY + chartH * (1 - this.data.get(i - 1).getValue());
      rect(tickX - BAR_WIDTH/2, rectHeight, BAR_WIDTH, chartY + chartH - rectHeight);
      fill(0);
      text(getCharForNumber(i), tickX, rectHeight + (chartY + chartH - rectHeight)/2);  
    }
    
    // y ticks
    textSize(TEXT_SIZE);
    stroke(0);
    fill(0);
    int ygaps = NUM_GAPS;
    for (int i = 0; i < ygaps + 1; i++) {
      String tickStr = String.valueOf((ygaps - i) * (MAX_VALUE/NUM_GAPS));
      float tickY = chartY + i * chartH / ygaps;
      line(chartX, tickY, chartX - 5, tickY);
      text(tickStr, chartX - textWidth(tickStr), tickY + 5);
    }

    line(chartX, chartY + chartH, chartX + chartW, chartY + chartH); // x axis
    line(chartX, chartY, chartX, chartY + chartH); // y axis
  }

  void drawAxes() {
    line(viewX, viewY, viewX , viewY + viewHeight);
    line(viewX, viewY + viewHeight, viewX + viewWidth, viewY + viewHeight);
  }

  void drawBars() {
    color dataColor = getPointColor();
    float gapSize = viewWidth / data.size;
    float rectWid = .8 * gapSize;
    float xStart = viewX + (gapSize - rectWid) / 2;
    float hgtRatio = viewHeight / data.getMax();

    for (int i = 0; i < data.size; i++) {
      fill(dataColor);
      float rectHgt = data.dataPoints[i].value * hgtRatio;
      rect(xStart + gapSize * i, viewY + viewHeight - rectHgt, rectWid, rectHgt);
    }
  }

  void drawEmbellishments() {
    
  }

  protected color getPointColor() {
    color themed = color(255, 105, 180);
    switch (COLOR_MODE) {
      case THEMED:
        return themed;
      case OPPOSITE:
        return color(255-red(themed), 255-green(themed), 255-blue(themed));
      default:
        return 255;
    }
  }
  
  protected int getMaxValue() {
    return MAX_VALUE; 
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
}