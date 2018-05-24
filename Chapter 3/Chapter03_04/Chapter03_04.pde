PImage img;

void setup() {
  size(750, 750);
  img = createImage(width, height, ARGB);
  noLoop();
}

void draw() {
  background(0);
  img.loadPixels();
  float colStep = 256.0/max(img.width/2, img.height/2);
  PVector ctr = new PVector(img.width/2, img.height/2);
  for (int y=0; y<img.height; y++) {
    int rows = y*img.width;
    for (int x=0; x<img.width; x++) {
      float d = distance(ctr, new PVector(x, y));
      color col = color(d*colStep, 0, 255-d*colStep);
      img.pixels[rows+x] = col;
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}

float distance(PVector p1, PVector p2) {
  float d = abs(p1.x-p2.x) + abs(p1.y-p2.y);
  return d;
}