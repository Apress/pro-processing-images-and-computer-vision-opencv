import processing.video.*;

Capture cap;

void setup() {
  size(640, 480);
  background(0);
  cap = new Capture(this, width, height);
  cap.start();
}

void draw() {
  image(cap, 0, 0);
}

void captureEvent(Capture c) {
  c.read();
}