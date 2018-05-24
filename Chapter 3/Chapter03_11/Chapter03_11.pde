PImage img;
float value1;
float range;

void setup() {
  size(750, 750);
  img = createImage(width, height, ARGB);
  img.loadPixels();
  value1 = floor(random(0, 256));
  range = 50;
  noLoop();
}

void draw() {
  background(0);
  for (int i=0; i<img.pixels.length; i++) {
    float v = random(-range, range);
    value1 += v;
    value1 = constrain(value1, 0, 255);
    img.pixels[i] = color(value1);
  }
  img.updatePixels();
  image(img, 0, 0);
}