final int DEFAULT_CANVAS_WIDTH  = 900;
final int DEFAULT_CANVAS_HEIGHT = 700;

public enum ColorMode {
  THEMED, OPPOSITE, NONE
}
final ColorMode COLOR_MODE = ColorMode.NONE; // themed, opposite, none

ExperimentKeeper experimentKeeper;

void setup(){
  fullScreen();
  int canvasWidth = DEFAULT_CANVAS_WIDTH;
  int canvasHeight = DEFAULT_CANVAS_HEIGHT;

  if(canvasWidth <= displayWidth && canvasHeight <= displayHeight){
    int canvasX = (displayWidth - canvasWidth) / 2;
    int canvasY = (displayHeight - canvasHeight) / 2;
    experimentKeeper = new ExperimentKeeper(canvasX, canvasY, canvasWidth, canvasHeight);
    surface.setResizable(false);
  }else{
    println("*** Display size < Canvas size ***");
    println("Display: " + displayWidth + "x" + displayHeight);
    println("Canvas: " + canvasWidth + "x" + canvasHeight);
    exit();
  }
}

void draw(){
  background(255);
  experimentKeeper.draw();
}

void mouseClicked(){
  experimentKeeper.onMouseClickedAt(mouseX, mouseY);
}

void keyTyped(){
  experimentKeeper.onKeyTyped(key);
}

String getCharForNumber(int i) {
    return i > 0 && i < 27 ? String.valueOf((char)(i + 64)) : null;
}