PImage source, grey;

void setup() {
  size(1200, 600);
  source = loadImage("sample04.jpg");
  grey = createImage(source.width, source.height, ARGB);
  noLoop();
}

void draw() {
  background(0);
  arrayCopy(source.pixels, grey.pixels);
  grey.updatePixels();
  grey.filter(GRAY);
  image(source, 0, 0);
  image(grey, source.width, 0);
  saveFrame("data/grey####.jpg");
}