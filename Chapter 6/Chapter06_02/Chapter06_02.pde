// Slit scan effect
import processing.video.*;

Capture cap;
PImage img;
int idx, mid;

void setup() {
  size(1280, 480);
  background(0);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = createImage(1, cap.height, ARGB);
  idx = 0;
  mid = cap.width/2;
}

void draw() {
  if (!cap.available()) 
    return;
  cap.read();
  img.copy(cap, mid, 0, 1, cap.height, 
    0, 0, img.width, img.height);
  image(img, idx, 0);
  idx++;
  idx %= width;
}

void mousePressed() {
  saveFrame("data/slit####.png");
}