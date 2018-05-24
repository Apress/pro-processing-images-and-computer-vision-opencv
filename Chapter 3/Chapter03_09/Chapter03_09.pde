PImage img;
float num;

void setup() {
  size(750, 750);
  img = createImage(width, height, ARGB);
  img.loadPixels();
  num = 2;
}

void draw() {
  background(0);
  PVector mouse = new PVector(mouseX, mouseY);
  for (int y=0; y<img.height; y++) {
    int rows = y*img.width;
    for (int x=0; x<img.width; x++) {
      float dist = distance(mouse, new PVector(x, y));
      float range = map(dist, -img.width, img.width, -PI*num*y, PI*num*x);
      float xCol = map(sin(range), -1, 1, 0, 255);
      float yCol = map(cos(range), -1, 1, 0, 255);
      color col = color(0, 255-xCol, yCol);
      img.pixels[rows+x] = col;
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}

float distance(PVector p1, PVector p2) {
  return p1.dist(p2);
}