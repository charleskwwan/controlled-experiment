public class BarChart extends Chart {
  public BarChart(Data data, int chartX, int chartY, int chartWidth, int chartHeight){
    super(data, chartX, chartY, chartWidth, chartHeight);
    this.name = "bar";
  }
  
  @Override
  void draw() {
    stroke(0);
    strokeWeight(1);
    fill(255);
    fill(0);

    drawAxes();
    drawBars();
  }

  void drawAxes() {
    line(viewX, viewY, viewX , viewY + viewHeight);
    line(viewX, viewY + viewHeight, viewX + viewWidth, viewY + viewHeight);
  }

  void drawBars() {
    float gapSize = viewWidth / data.size;
    float rectWid = .8 * gapSize;
    float xStart = viewX + (gapSize - rectWid) / 2;
    float hgtRatio = viewHeight / data.getMax();

    for (int i = 0; i < data.size; i++) {
      fill(255);
      float rectHgt = data.dataPoints[i].value * hgtRatio;
      rect(xStart + gapSize * i, viewY + viewHeight - rectHgt, rectWid, rectHgt);
    }
  }
}