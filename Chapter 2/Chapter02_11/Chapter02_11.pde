import processing.video.*;

Capture cap;
PGraphics pg;

void setup() {
  size(640, 480);
  background(0);
  cap = new Capture(this, width, height);
  cap.start();
  pg = createGraphics(width, height);
  pg.beginDraw();
  pg.noStroke();
  pg.fill(255);
  pg.background(0);
  pg.endDraw();
}

void draw() {
  if (cap.available()) {
    cap.read();
  }
  tint(255, 0, 0, 40);
  cap.mask(pg);
  image(cap, 0, 0);
}

void mouseDragged() {
  pg.beginDraw();
  pg.ellipse(mouseX, mouseY, 20, 20);
  pg.endDraw();
}