import processing.video.*;
import java.util.ArrayList;

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
  Imgproc.blur(tmp1, tmp2, new Size(5, 5));
  Imgproc.threshold(tmp2, tmp1, 80, 255, Imgproc.THRESH_BINARY);
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  tmp1 = tmp2.clone();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(tmp1);
  image(out, 0, 0);
  pushStyle();
  noFill();
  stroke(255, 255, 0);
  for (MatOfPoint ps : contours) {
    Point [] pts = ps.toArray();
    for (int i=0; i<pts.length-1; i++) {
      Point p1 = pts[i];
      Point p2 = pts[i+1];
      line((float)p1.x+cap.width, (float)p1.y, (float)p2.x+cap.width, (float)p2.y);
    }
  }
  noStroke();
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();

  tmp1.release();
  tmp2.release();
}

void mousePressed() {
  saveFrame("data/contours.png");
}