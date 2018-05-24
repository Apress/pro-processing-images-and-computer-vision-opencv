PImage source, blur;

void setup() {
  size(1200, 600);
  source = loadImage("sample03.jpg");
  blur = createImage(source.width, source.height, ARGB);
  noLoop();
}

void draw() {
  background(0);
  arrayCopy(source.pixels, blur.pixels);
  blur.updatePixels();
  blur.filter(BLUR, 3);
  image(source, 0, 0);
  image(blur, source.width, 0);
  saveFrame("data/blur.jpg");
}