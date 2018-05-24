import java.lang.Math;

PImage img;

void setup() {
  size(750, 750);
  img = createImage(width, height, ARGB);
  noLoop();
}

void draw() {
  background(0);
  img.loadPixels();
  float colStep = 256.0/colFunc(img.height);
  for (int y=0; y<img.height; y++) {
    int rows = y*img.width;
    color col = color(colFunc(y)*colStep);
    for (int x=0; x<img.width; x++) {
      img.pixels[rows+x] = col;
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}

float colFunc(float v) {
  return (float) Math.pow(v, 1.5);
}