PGraphics pg;
boolean toDraw;

void setup() {
  size(640, 480);
  background(0);
  pg = createGraphics(width, height);
  toDraw = false;
}

void draw() {
  if (toDraw) 
    image(pg, 0, 0);
}

void mouseDragged() {
  pg.beginDraw();
  pg.noStroke();
  pg.fill(255, 100, 0);
  pg.ellipse(mouseX, mouseY, 20, 20);
  pg.endDraw();
}

void mousePressed() {
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();
  toDraw = false;
}

void mouseReleased() {
  toDraw = true;
}