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
  Imgproc.GaussianBlur(tmp1, tmp2, new Size(7, 7), 1.5, 1.5);
  Imgproc.threshold(tmp2, tmp1, 110, 255, Imgproc.THRESH_BINARY);
  Imgproc.Canny(tmp1, tmp2, 10, 30);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(tmp2);
  img.copyTo(tmp1);
  image(img, 0, 0);
  image(out, img.width, 0);
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
}

void mousePressed() {
  saveFrame("data/Canny.png");
}