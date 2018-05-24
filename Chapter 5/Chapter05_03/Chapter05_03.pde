PImage source, grey, bw;

void setup() {
  size(1800, 600);
  source = loadImage("sample01.jpg");
  grey = createImage(source.width, source.height, ARGB);
  bw = createImage(source.width, source.height, ARGB);
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
  image(source, 0, 0);
  image(grey, source.width, 0);
  image(bw, source.width+grey.width, 0);
  saveFrame("data/bw####.jpg");
}