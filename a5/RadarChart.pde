public class RadarChart extends Chart {
  private final int numRanges = 5;
  private final int maxRange = 100;

  private float centerX, centerY;

  private String[] columns;
  private PShape dataShape;

  public RadarChart(Data data, int chartX, int chartY, int chartWidth, int chartHeight, String[] columns){
    super(data, chartX, chartY, chartWidth, chartHeight);
    this.name = "bar";
    this.columns = columns;
    this.centerX = chartX + chartWidth / 2;
    this.centerY = chartY + chartHeight / 2;
  }
  
  @Override
  void draw() {
    stroke(0);
    strokeWeight(1);
    fill(255);
    fill(0);

    float rad = getRadius() / this.numRanges;
    float offset = -TWO_PI / (2 * this.columns.length);

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
      if (textp.x < getCenterX()) {
        textp.x -= textWidth(col);
      } else if (textp.x == getCenterX()) {
        textp.x -= textWidth(col) / 2;
      }
      textp.y += (textAscent() + textDescent()) * 0.2;
      fill(0);
      text(col, textp.x, textp.y);

      // hexagon
      for (int j = 0; j <= this.numRanges; j++) {
        p1 = calcPoint(offset, j * rad);
        p2 = calcPoint(next, j * rad);
        line(p1.x, p1.y, p2.x, p2.y);
        
        if (i == this.columns.length - 1)              // range labels
          text(String.valueOf(float(maxRange) / numRanges * j), p1.x, p1.y);        
      }

      offset = next;
    }
    
    // shape
    offset = -TWO_PI / (2 * this.columns.length);
    beginShape();
    fill(255, 154, 154, 75);    // TODO: this color needs to change depending on trial
    strokeWeight(2);
    stroke(#F44336);
    for (int i = 0; i < this.columns.length; i++) {
      float valueRatio = this.data.dataPoints[i].getValue() / this.maxRange;
      PVector p = calcPoint(offset, getRadius() * valueRatio);
      vertex(p.x, p.y);
      offset += TWO_PI / this.columns.length;
    }
    endShape(CLOSE);
  }

  //private PShape makeColShape() {
  //  HashMap<String, Float> colVals = new HashMap<String, Float>();

  //}

  private float getRadius() {
    return min(getWidth(), getHeight()) / 2 - 2 * (textAscent() + textDescent() + 5);
  }

  private PVector calcPoint(float a, float r) {
    return new PVector(this.centerX + cos(a) * r, this.centerY + sin(a) * r);
  }
}