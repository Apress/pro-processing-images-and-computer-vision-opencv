PImage source;
CVImage srccv, bwcv;

void setup() {
  size(1800, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  source = loadImage("sample04.jpg");
  srccv = new CVImage(source.width, source.height);
  bwcv = new CVImage(source.width, source.height);
  srccv.copyTo(source);
  noLoop();
}

void draw() {
  background(0);
  Mat grey = srccv.getGrey();
  Mat bw = new Mat();
  Imgproc.threshold(grey, bw, 127, 255, Imgproc.THRESH_BINARY);
  bwcv.copyTo(bw);
  srccv.copyTo(grey);
  image(source, 0, 0);
  image(srccv, source.width, 0);
  image(bwcv, source.width+srccv.width, 0);
  grey.release();
  bw.release();
}