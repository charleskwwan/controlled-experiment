public class Data {

  private int size;
  private DataPoint[] dataPoints;

  public Data(int size){
    this.size = size;
    this.dataPoints = new DataPoint[size];

    //ToDo: how to generate data points and mark two of the data points
  }

  //ToDo: feel free to add varialves and methods for your convenience


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