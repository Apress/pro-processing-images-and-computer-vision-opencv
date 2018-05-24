PImage img;

void setup() {
  size(750, 750);
  img = createImage(width, height, ARGB);
  noLoop();
}

void draw() {
  background(0);
  img.loadPixels();
  float xStep = 256.0/img.width;
  float yStep = 256.0/img.height;
  for (int y=0; y<img.height; y++) {
    int rows = y*img.width;
    for (int x=0; x<img.width; x++) {
      img.pixels[rows+x] = color(x*xStep, 0, y*yStep);
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}