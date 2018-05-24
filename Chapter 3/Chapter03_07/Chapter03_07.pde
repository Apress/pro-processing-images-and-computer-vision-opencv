PImage img;
float num;

void setup() {
  size(750, 750);
  img = createImage(width, height, ARGB);
  img.loadPixels();
  num = 8;
}

void draw() {
  background(0);
  PVector mouse = new PVector(mouseX, mouseY);
  for (int y=0; y<img.height; y++) {
    int rows = y*img.width;
    for (int x=0; x<img.width; x++) {
      PVector dist = distance(mouse, new PVector(x, y));
      float xRange = map(dist.x, -img.width, img.width, -PI*num, PI*num);
      float yRange = map(dist.y, -img.height, img.height, -PI*num, PI*num);
      float xCol = map(cos(xRange), -1, 1, 0, 255);
      float yCol = map(sin(yRange), -1, 1, 0, 255);
      color col = color(xCol, 0, yCol);
      img.pixels[rows+x] = col;
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}

PVector distance(PVector p1, PVector p2) {
  return PVector.sub(p1, p2);
}