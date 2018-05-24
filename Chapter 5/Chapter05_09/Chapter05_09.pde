import processing.video.*;

Capture cap;

void setup() {
  size(1280, 480);
  cap = new Capture(this, width/2, height);
  cap.start();
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  PImage tmp = createImage(cap.width, cap.height, ARGB);
  arrayCopy(cap.pixels, tmp.pixels);
  tmp.filter(GRAY);
  tmp.filter(BLUR, 2);
  tmp.filter(THRESHOLD, 0.25);
  tmp.filter(DILATE);
  image(cap, 0, 0);
  image(tmp, cap.width, 0);
  text(nf(round(frameRate), 2), 10, 20);
}

void mousePressed() {
  saveFrame("data/testSample.png");
}