import processing.video.*;

Capture cap;
PShape canvas;
int capW, capH;
float step;

void setup() {
  size(800, 600, P3D);
  hint(DISABLE_DEPTH_TEST);
  capW = 640;
  capH = 480;
  step = 40;
  cap = new Capture(this, capW, capH);
  cap.start();
  initShape();
  shapeMode(CENTER);
}

void initShape() {
  // initialize the GROUP PShape grid
  canvas = createShape(GROUP);
  int nRows = floor(cap.height/step) + 1;
  int nCols = floor(cap.width/step) + 1;
  for (int y=0; y<nRows-1; y++) {
    // initialize each row of the grid
    PShape tmp = createShape();
    tmp.beginShape(QUAD_STRIP);
    tmp.texture(cap);
    for (int x=0; x<nCols; x++) {
      // initialize the top-left, bottom-left points
      int x1 = (int)constrain(x*step, 0, cap.width-1);
      int y1 = (int)constrain(y*step, 0, cap.height-1);
      int y2 = (int)constrain((y+1)*step, 0, cap.height-1);
      tmp.vertex(x1, y1, 0, x1, y1);
      tmp.vertex(x1, y2, 0, x1, y2);
    }
    tmp.endShape();
    canvas.addChild(tmp);
  }
}

void draw() {
  if (!cap.available()) 
    return;
  cap.read();
  lights();
  background(100);
  translate(width/2, height/2, -80);
  rotateX(radians(20));
  shape(canvas, 0, 0);
}

void mousePressed() {
  saveFrame("data/shape.png");
}