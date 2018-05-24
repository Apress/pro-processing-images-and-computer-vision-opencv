import processing.video.*;

Capture cap;
PImage img;
PShape canvas;
int capW, capH;
float angle;

void setup() {
  size(800, 600, P3D);
  hint(DISABLE_DEPTH_TEST);
  capW = 640;
  capH = 480;
  cap = new Capture(this, capW, capH);
  cap.start();
  img = loadImage("hongkong.png");
  canvas = createShape(RECT, 0, 0, cap.width, cap.height);
  canvas.setStroke(false);
  canvas.setTexture(cap);
  shapeMode(CENTER);
  angle = 0;
}

void draw() {
  if (!cap.available()) 
    return;
  cap.read();
  background(0);
  image(img, 0, 0);
  translate(width/2, height/2, -100);
  rotateX(radians(angle));
  shape(canvas, 0, 0);
  angle += 0.5;
  angle %= 360;
}

void mousePressed() {
  saveFrame("data/shape.png");
}