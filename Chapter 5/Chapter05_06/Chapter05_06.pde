PImage source;
CVImage srccv, bwcv, erodecv, dilatecv;

void setup() {
  size(1800, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  source = loadImage("sample02.jpg");
  srccv = new CVImage(source.width, source.height);
  bwcv = new CVImage(source.width, source.height);
  erodecv = new CVImage(source.width, source.height);
  dilatecv = new CVImage(source.width, source.height);
  srccv.copyTo(source);
  noLoop();
}

void draw() {
  background(0);
  Mat grey = srccv.getGrey();
  Mat bw = new Mat();
  Imgproc.threshold(grey, bw, 127, 255, Imgproc.THRESH_BINARY);
  Mat erode = new Mat();
  Mat dilate = new Mat();
  Mat elem = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, new Size(3, 3));
  Imgproc.erode(bw, erode, elem);
  Imgproc.dilate(bw, dilate, elem);
  bwcv.copyTo(bw);
  erodecv.copyTo(erode);
  dilatecv.copyTo(dilate);
  image(bwcv, 0, 0);
  image(erodecv, bwcv.width, 0);
  image(dilatecv, bwcv.width+erodecv.width, 0);
  grey.release();
  bw.release();
  erode.release();
  dilate.release();
  saveFrame("data/morpho.jpg");
}