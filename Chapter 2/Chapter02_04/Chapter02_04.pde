PGraphics pg;

void setup() {
  size(640, 480);
  background(100, 100, 100);
  pg = getGraphics();
  noLoop();
}

void draw() {
  rect(0, 0, 200, 120);
  image(pg, 200, 120);
}