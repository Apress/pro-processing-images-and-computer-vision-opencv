import processing.video.*;

Capture cap;
CVImage img;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  noStroke();
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copyTo(cap);
  Mat tmp1 = img.getGrey();
  Mat tmp2 = new Mat();
  Imgproc.Canny(tmp1, tmp2, 50, 150);
  MatOfPoint2f lines = new MatOfPoint2f();
  Imgproc.HoughLines(tmp2, lines, 1, PI/180, 100);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(tmp2);
  image(cap, 0, 0);
  image(out, cap.width, 0);
  Point [] points = lines.toArray();
  pushStyle();
  noFill();
  stroke(255);
  for (Point p : points) {
    double rho = p.x;
    double theta = p.y;
    double a = cos((float)theta);
    double b = sin((float)theta);
    PVector pt1, pt2;
    double x0 = rho*a;
    double y0 = rho*b;
    pt1 = new PVector((float)(x0 + cap.width*(-b)), (float)(y0 + cap.width*(a)));
    pt2 = new PVector((float)(x0 - cap.width*(-b)), (float)(y0 - cap.width*(a)));
    line(pt1.x, pt1.y, pt2.x, pt2.y);
  }
  popStyle();
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
  lines.release();
}

void mousePressed() {
  saveFrame("data/Canny.png");
}