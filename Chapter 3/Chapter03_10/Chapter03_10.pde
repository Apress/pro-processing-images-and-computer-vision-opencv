PImage img;

void setup() {
  size(750, 750);
  img = createImage(width, height, ARGB);
  img.loadPixels();
  noLoop();
}

void draw() {
  background(0);
  for (int i=0; i<img.pixels.length; i++) {
    img.pixels[i] = color(floor(random(0, 256)));
  }
  img.updatePixels();
  image(img, 0, 0);
}