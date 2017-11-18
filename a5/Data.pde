public class Data{

  private int size;
  private DataPoint[] dataPoints;

  public Data(int size){
    this.size = size;
    this.dataPoints = new DataPoint[size];
    
    // Choose two indices to mark
    int firstMarked = int(random(0, size));
    int secondMarked = int(random(0, size));
    while (firstMarked == secondMarked) {
      secondMarked = int(random(0, size));
    }
    
    for (int i = 0; i < size; i++) {
        this.dataPoints[i] = new DataPoint(random(0, 100));
    }
  }
  
  public float getMax() {
    float max = 0;
    for (int i = 0; i < this.size; i++) {
       max = max(dataPoints[i].value, max);
    }
    return max;
  }
 
  public float getSum() {
    float sum = 0;
    for (int i = 0; i < this.size; i++) {
       sum += dataPoints[i].value;
    }
    return sum;
  }


  public int size(){
    return this.size;
  }

  private class DataPoint{
    private float value;
   
    public DataPoint(float value){
      this.value = value;
    }

    public float getValue(){
      return this.value;
    }

  }

}