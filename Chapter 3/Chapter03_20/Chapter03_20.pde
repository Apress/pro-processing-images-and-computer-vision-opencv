PImage img;

void setup() {
  size(1200, 900);
  background(0);
  img = loadImage("christmas.png");
  img.loadPixels();
  noFill();
  noLoop();
}

void draw() {
  int y = img.height/2;
  for (int x=0; x<img.width; x++) {
    color c = img.pixels[y*img.width+x];
    stroke(c);
    line(x, 0, x, img.height-1);
  }
}