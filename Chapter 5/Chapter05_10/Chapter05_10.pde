import processing.video.*;

Capture cap;
CVImage img;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copyTo(cap);
  Mat tmp1 = img.getGrey();
  Mat tmp2 = new Mat();
  Imgproc.GaussianBlur(tmp1, tmp2, new Size(5, 5), 0);
  Imgproc.threshold(tmp2, tmp1, 80, 255, Imgproc.THRESH_BINARY);
  Mat elem = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, new Size(3, 3));
  Imgproc.dilate(tmp1, tmp2, elem);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(tmp2);
  image(cap, 0, 0);
  image(out, cap.width, 0);
  tmp1.release();
  tmp2.release();
  elem.release();
  text(nf(round(frameRate), 2), 10, 20);
}