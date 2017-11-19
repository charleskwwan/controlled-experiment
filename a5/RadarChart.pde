public class RadarChart extends Chart {
  private final int numRanges = 5;
  private final int maxRange = 20;
  private final int TEXT_SIZE = 10;
  private final int PT_RADIUS = 3;

  private float centerX, centerY;

  private String title;
  private String[] columns;

  public RadarChart(Data data, int chartX, int chartY, int chartWidth, int chartHeight){
    super(data, chartX, chartY, chartWidth, chartHeight);
    this.name = "RadarChart";
    this.title = "Tufts Abroad Programs";
    this.yhead = "Num Students";
    this.xhead = "Countries";
    this.columns = new String[] {"Hong Kong", "Ghana", "London", "Chile", "Japan"};
    this.centerX = chartX + chartWidth / 2;
    this.centerY = chartY + chartHeight / 2;
  }
  
  @Override
  void draw() {
    color dataColor = getPointColor();
    float x = getX(), y = getY(), w = getWidth(), h = getHeight();
    float chartX = getChartX(), chartY = getChartY();
    float chartW = getChartWidth(), chartH = getChartHeight();
    float rad = getRadius() / this.numRanges;
    float offset = -(TWO_PI) / (2 * this.columns.length) - (3*PI/2);
    
    // bg
    //noStroke();
    //fill(255);
    //rect(x, y, w, h);
    
    stroke(0);
    strokeWeight(1);
    fill(0);

    // title
    textSize(TEXT_SIZE * 2);
    text(this.title, x + w/2, y + (textAscent() + textDescent())/2);

    textSize(TEXT_SIZE);
    for (int i = 0; i < this.columns.length; i++) {
      float next = offset + TWO_PI / this.columns.length;

      // lines
      PVector p1 = calcPoint(offset, getRadius()), p2 = calcPoint(next, getRadius());
      stroke(230, 25);
      line(getCenterX(), getCenterY(), PVector.lerp(p1, p2, 0.5).x, PVector.lerp(p1, p2, 0.5).y);
      stroke(0);
      line(getCenterX(), getCenterY(), p1.x, p1.y);

      // column labels
      PVector textp = calcPoint(offset, getRadius() + 10);
      String col = this.columns[i];
      if (textp.x <= getCenterX()) {
        textp.x -= textWidth(col) / 2;
      } else {
        textp.x += textWidth(col) / 2;
      }
      textp.y += (textAscent() + textDescent()) * 0.2;
      fill(0);
      text(col, textp.x, textp.y);

      // hexagon
      for (int j = 0; j <= this.numRanges; j++) {
        p1 = calcPoint(offset, j * rad);
        p2 = calcPoint(next, j * rad);
        line(p1.x, p1.y, p2.x, p2.y);
        
        if (i == this.columns.length - 2) {             // range labels
          String label = String.valueOf(int(float(maxRange) / numRanges * j));
          text(label, p1.x + 7, p1.y);  
        }
      }

      offset = next;
    }
    
    // shape
    offset = -TWO_PI / (2 * this.columns.length) - (3*PI/2);
    PVector[] vertices = new PVector[this.columns.length];
    beginShape();
    fill(dataColor, 75);
    stroke(dataColor);
    strokeWeight(2);
    for (int i = 0; i < this.columns.length; i++) {
      PVector p = calcPoint(offset, getRadius() * this.data.dataPoints[i].getValue());
      vertex(p.x, p.y);
      ellipse(p.x, p.y, PT_RADIUS, PT_RADIUS);
      vertices[i] = p;
      offset += TWO_PI / this.columns.length;
    }
    endShape(CLOSE);
    
    // draw point labels
    fill(0);
    textSize(TEXT_SIZE * 1.15);
    for (int i = 0; i < vertices.length; i++) {
      text(getCharForNumber(i+1), vertices[i].x - 5, vertices[i].y - 5);
    }
  }
  
  private float getRadius() {
    return min(getWidth(), getHeight()) / 2 - 2 * (textAscent() + textDescent() + 5);
  }

  private PVector calcPoint(float a, float r) {
    return new PVector(this.centerX + cos(a) * r, this.centerY + sin(a) * r);
  }
  
  protected color getPointColor() {
    color themed = color(62, 142, 222);
    switch (COLOR_MODE) {
      case THEMED:
        return themed;
      case OPPOSITE:
        return color(325-red(themed), 255-green(themed), 255-blue(themed));
      default:
        return 0;
    }
  }
  
  protected float scaleValue(float trueValue) {
    return trueValue * maxRange;
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