// Mosaic effect
import processing.video.*;

final int CELLS = 40;
Capture cap;
PImage img;
int idx;
int rows, cols;

void setup() {
  size(960, 720);
  background(0);
  cap = new Capture(this, 640, 480);
  cap.start();
  rows = CELLS;
  cols = CELLS;
  img = createImage(width/cols, height/rows, ARGB);
  idx = 0;
}

void draw() {
  if (!cap.available()) 
    return;
  cap.read();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  int px = idx % cols;
  int py = idx / cols;
  int ix = px*cap.width/cols;
  int iy = py*cap.height/rows;
  color col = cap.pixels[iy*cap.width+ix];
  tint(col);
  image(img, px*img.width, py*img.height);
  idx++;
  idx %= (rows*cols);
}

void mousePressed() {
  saveFrame("data/mosaic####.png");
}