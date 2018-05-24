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
    Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE);
  image(cap, 0, 0);
  pushStyle();
  noFill();
  stroke(255, 255, 0);
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) {
    Point [] pts = it.next().toArray();
    for (int i=0; i<pts.length-1; i++) {
      Point p1 = pts[i];
      Point p2 = pts[i+1];
      line((float)p1.x+cap.width, (float)p1.y, (float)p2.x+cap.width, (float)p2.y);
    }
  }
  popStyle();
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
}

void mousePressed() {
  saveFrame("data/contours.png");
}