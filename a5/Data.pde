public enum Order {
  INCREASING, DECREASING, RANDOM
}

public class Data {

  private int size;
  private DataPoint[] dataPoints;
  
  public Data(int size) {
    this(size, Order.RANDOM);
  }
  
  public Data(int size, Order order){
    this.size = size;
    this.dataPoints = new DataPoint[size];

    float lo = 0.05, hi = 0.95;
    for (int i = 0; i < size; i++) {
      float value = (random(lo, hi) + random(lo, hi)) / 2;
      this.dataPoints[i] = new DataPoint(value, false);
      if (order == Order.INCREASING)
        lo = value;
      else if (order == Order.DECREASING)
        hi = value;
    }
  }

  public int size(){
    return this.size;
  }

  public DataPoint get(int i) {
    return this.dataPoints[i];
  }

  private class DataPoint{
    private float value;
    private boolean isMarked;

    public DataPoint(float value, boolean isMarked){
      this.value = value;
      this.isMarked = isMarked;
    }

    public boolean isMarked(){
      return this.isMarked;
    }

    public float getValue(){
      return this.value;
    }

  }

}