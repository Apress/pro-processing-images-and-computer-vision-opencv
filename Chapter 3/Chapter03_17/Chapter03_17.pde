PImage img;
int step;

void setup() {
  size(1500, 750);
  background(0);
  img = loadImage("landscape.png");
  img.loadPixels();
  step = 10;
  noStroke();
  noLoop();
}

void draw() {
  for (int y=0; y<img.height; y+=step) {
    int rows = y*img.width;
    for (int x=0; x<img.width; x+=step) {
      color col = img.pixels[rows+x];
      fill(col);
      rect(x+img.width, y, step, step);
    }
  }
  image(img, 0, 0);
  saveFrame("data/mosaic.png");
}