PImage source;
CVImage srccv, blurcv, mediancv, gaussiancv;

void setup() {
  size(1800, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  source = loadImage("sample03.jpg");
  srccv = new CVImage(source.width, source.height);
  blurcv = new CVImage(source.width, source.height);
  mediancv = new CVImage(source.width, source.height);
  gaussiancv = new CVImage(source.width, source.height);
  srccv.copyTo(source);
  noLoop();
}

void draw() {
  background(0);
  Mat mat = srccv.getBGR();
  Mat blur = new Mat();
  Mat median = new Mat();
  Mat gaussian = new Mat();
  Imgproc.medianBlur(mat, median, 9);
  Imgproc.blur(mat, blur, new Size(9, 9));
  Imgproc.GaussianBlur(mat, gaussian, new Size(9, 9), 0);
  blurcv.copyTo(blur);
  mediancv.copyTo(median);
  gaussiancv.copyTo(gaussian);
  //image(source, 0, 0);
  image(blurcv, 0, 0);
  image(mediancv, blurcv.width, 0);
  image(gaussiancv, blurcv.width+mediancv.width, 0);
  mat.release();
  blur.release();
  median.release();
  gaussian.release();
  saveFrame("data/moreblur.jpg");
}