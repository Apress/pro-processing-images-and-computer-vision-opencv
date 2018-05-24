PImage img;
int step;

void setup() {
  size(1200, 900);
  background(0);
  img = loadImage("christmas.png");
  img.loadPixels();
  println(img.width);
  println(img.height);
  step = 8;
  smooth();
  noFill();
  noLoop();
}

void draw() {
  for (int y=0; y<img.height; y+=step) {
    int rows = y*img.width;
    for (int x=0; x<img.width; x+=step) {
      color col = img.pixels[rows+x];
      stroke(col);
      int num = floor(random(2));
      if (num == 0) {
        line(x, y, x+step, y+step);
      } else {
        line(x+step, y, x, y+step);
      }
    }
  }
//  image(img, 0, 0);
  saveFrame("data/mosaic.png");
}