import processing.video.*;
import java.util.ArrayList;
import java.util.Iterator;

Capture cap;
PImage img;
CVImage cv;
MatOfPoint ch;
float maxVal;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = loadImage("chinese.png");
  ch = prepareChar(img);
  cv = new CVImage(cap.width, cap.height);
  maxVal = 5;
}

MatOfPoint prepareChar(PImage i) {
  CVImage chr = new CVImage(i.width, i.height);
  chr.copyTo(i);
  Mat tmp1 = chr.getGrey();
  Mat tmp2 = new Mat();
  Imgproc.blur(tmp1, tmp2, new Size(3, 3));
  Imgproc.threshold(tmp2, tmp1, 127, 255, Imgproc.THRESH_BINARY);
  Mat hierarchy = new Mat();
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  tmp1.release();
  tmp2.release();
  hierarchy.release();
  return contours.get(0);
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  cv.copyTo(cap);
  Mat tmp1 = cv.getGrey();
  Mat tmp2 = new Mat();
  Imgproc.blur(tmp1, tmp2, new Size(3, 3));
  Imgproc.Canny(tmp2, tmp1, 100, 200);
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  Iterator<MatOfPoint> it = contours.iterator();
  pushStyle();
  while (it.hasNext()) {
    MatOfPoint cont = it.next();
    double val = Imgproc.matchShapes(ch, cont, Imgproc.CV_CONTOURS_MATCH_I3, 0);
    if (val > maxVal) 
      continue;
    RotatedRect r = Imgproc.minAreaRect(new MatOfPoint2f(cont.toArray()));
    Point ctr = r.center;
    noStroke();
    fill(255, 200, 0);
    text((float)val, (float)ctr.x+cap.width, (float)ctr.y);
    Point [] pts = cont.toArray();
    noFill();
    stroke(100);
    beginShape();
    for (int i=0; i<pts.length; i++) {
      vertex((float)pts[i].x+cap.width, (float)pts[i].y);
    }
    endShape(CLOSE);
  }
  popStyle();
  image(cap, 0, 0);
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
  hierarchy.release();
}

void mousePressed() {
  saveFrame("data/match####.png");
}