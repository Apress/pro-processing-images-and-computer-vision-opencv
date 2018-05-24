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
  Imgproc.GaussianBlur(tmp1, tmp2, new Size(9, 9), 1);
  Imgproc.Canny(tmp2, tmp1, 100, 200);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(tmp1);
  MatOfPoint3f circles = new MatOfPoint3f();
  Imgproc.HoughCircles(tmp1, circles, Imgproc.HOUGH_GRADIENT, 1, tmp1.rows()/8, 200, 45, 0, 0);
  Point3 [] points = circles.toArray();
  image(cap, 0, 0);
  image(out, cap.width, 0);
  pushStyle();
  noStroke();
  fill(0, 0, 255, 100);
  for (Point3 p : points) {
    ellipse((float)p.x, (float)p.y, (float)(p.z*2), (float)(p.z*2));
  }
  popStyle();
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
  circles.release();
}

void mousePressed() {
  saveFrame("data/circles.png");
}