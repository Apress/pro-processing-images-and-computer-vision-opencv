PImage img;

void setup() {
  size(750, 750);
  background(0);
  img = createImage(width, height, ARGB);
  noLoop();
}

void draw() {
  img.loadPixels();
  color orange = color(255, 160, 0);
  for (int i=0; i<img.pixels.length; i++) {
    img.pixels[i] = orange;
  }
  img.updatePixels();
  image(img, 0, 0);
}