public class Data {

  private int size;
  private DataPoint[] dataPoints;

  public Data(int size){
    this.size = size;
    this.dataPoints = new DataPoint[size];
    
    // generate scalable pts from 20% (to prevent going too low) to 100%
    for (int i = 0; i < size; i++) {
      this.dataPoints[i] = new DataPoint(random(0.2, 1), false);
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