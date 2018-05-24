import processing.video.*;
import java.util.ArrayList;
import java.util.Iterator;

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
  Imgproc.blur(tmp1, tmp2, new Size(3, 3));
  Imgproc.Canny(tmp2, tmp1, 100, 200);
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  image(cap, 0, 0);
  pushStyle();
  noFill();
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) {
    strokeWeight(random(5));
    stroke(255, random(160, 256));
    MatOfPoint2f poly = new MatOfPoint2f();
    Imgproc.approxPolyDP(new MatOfPoint2f(it.next().toArray()), poly, 3, true);
    Point [] pts = poly.toArray();
    beginShape();
    for (int i=0; i<pts.length; i++) {
      vertex((float)pts[i].x+cap.width, (float)pts[i].y);
    }
    endShape(CLOSE);
  }
  popStyle();
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
}

void mousePressed() {
  saveFrame("data/contours.png");
}