public class TextField extends Viewport{

  private static final String CARET = "|";

  private String text;
  private boolean isEnabled;

  public TextField(int viewX, int viewY, int viewWidth, int viewHeight){
    super(viewX, viewY, viewWidth, viewHeight);
    this.text = "";
    this.isEnabled = false;
  }
  
  public void enable(){
    this.isEnabled = true;
  }

  public void disable(){
    this.isEnabled = false;
  }
  
  public boolean isEnabled() {
    return this.isEnabled;
  }

  public void clear(){
    this.text = "";
  }

  public void draw(String text){
    this.text = text;
    this.draw();
  }

  public void draw(){
    stroke(39, 102, 127);
    fill(18, 64, 85);
    rect(this.viewX, this.viewY, this.viewWidth, this.viewHeight);
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text(this.text + (this.isEnabled ? CARET : ""), this.viewX, this.viewCenterY);
  }

}