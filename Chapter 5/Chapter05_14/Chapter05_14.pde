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
  Imgproc.Canny(tmp1, tmp2, 50, 150);
  Mat lines = new Mat();
  Imgproc.HoughLinesP(tmp2, lines, 1, PI/180, 80, 30, 10);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(tmp2);
  image(out, cap.width, 0);
  pushStyle();
  fill(100);
  rect(0, 0, cap.width, cap.height);
  noFill();
  stroke(0);
  for (int i=0; i<lines.rows(); i++) {
    double [] pts = lines.get(i, 0);
    float x1 = (float)pts[0];
    float y1 = (float)pts[1];
    float x2 = (float)pts[2];
    float y2 = (float)pts[3];
    line(x1, y1, x2, y2);
  }
  popStyle();
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
  lines.release();
}

void mousePressed() {
  saveFrame("data/Lines.png");
}