PImage source;
CVImage srccv, greycv;

void setup() {
  size(1200, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  source = loadImage("sample04.jpg");
  srccv = new CVImage(source.width, source.height);
  srccv.copyTo(source);
  greycv = new CVImage(source.width, source.height);
  noLoop();
}

void draw() {
  background(0);
  Mat mat = srccv.getGrey();
  greycv.copyTo(mat);
  image(source, 0, 0);
  image(greycv, source.width, 0);
  mat.release();
  saveFrame("data/grey####.jpg");
}