PImage source, grey, bw, dilate, erode;

void setup() {
  size(1800, 600);
  source = loadImage("sample02.jpg");
  grey = createImage(source.width, source.height, ARGB);
  bw = createImage(source.width, source.height, ARGB);
  dilate = createImage(source.width, source.height, ARGB);
  erode = createImage(source.width, source.height, ARGB);
  noLoop();
}

void draw() {
  background(0);
  arrayCopy(source.pixels, grey.pixels);
  grey.updatePixels();
  grey.filter(GRAY);
  arrayCopy(grey.pixels, bw.pixels);
  bw.updatePixels();
  bw.filter(THRESHOLD, 0.5);
  arrayCopy(bw.pixels, erode.pixels);
  arrayCopy(bw.pixels, dilate.pixels);
  erode.updatePixels();
  dilate.updatePixels();
  dilate.filter(DILATE);
  erode.filter(ERODE);
  image(bw, 0, 0);
  image(erode, bw.width, 0);
  image(dilate, bw.width+erode.width, 0);
  saveFrame("data/morpho.jpg");
}