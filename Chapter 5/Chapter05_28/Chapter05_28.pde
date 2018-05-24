import processing.video.*;
import java.util.ArrayList;
import java.util.Iterator;

Capture cap;
CVImage img;
float minArea, maxArea;
RotatedRect rRect;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  minArea = 50;
  maxArea = 6000;
  // This is the fixed rectangular region of size 200x200.
  rRect = new RotatedRect(new Point(cap.width/2, cap.height/2), 
    new Size(200, 200), 0);
  rectMode(CENTER);
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
  // Draw the fixed rectangular region.
  pushStyle();
  fill(255, 20);
  stroke(0, 0, 255);
  rect((float)rRect.center.x+cap.width, 
    (float)rRect.center.y, (float)rRect.size.width, 
    (float)rRect.size.height);
  popStyle();

  pushStyle();
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) {
    MatOfPoint ctr = it.next();
    float area = (float)Imgproc.contourArea(ctr);
    // Exclude the large and small rectangles
    if (area < minArea || area > maxArea) 
      continue;
    // Obtain the rotated rectangles from each contour.
    RotatedRect r = Imgproc.minAreaRect(new MatOfPoint2f(ctr.toArray()));
    Point [] pts = new Point[4];
    r.points(pts);
    stroke(255, 255, 0);
    noFill();
    // Draw the rotated rectangles.
    beginShape();
    for (int i=0; i<pts.length; i++) {
      vertex((float)pts[i].x+cap.width, (float)pts[i].y);
    }
    endShape(CLOSE);
    // Compute the intersection between the fixed region and
    // each rotated rectangle.
    MatOfPoint2f inter = new MatOfPoint2f();
    int rc = Imgproc.rotatedRectangleIntersection(r, rRect, inter);
    //  Skip the cases with no intersection.
    if (rc == Imgproc.INTERSECT_NONE) 
      continue;
    // Obtain the convex hull of the intersection polygon.
    MatOfInt idx = new MatOfInt();
    MatOfPoint mp = new MatOfPoint(inter.toArray());
    Imgproc.convexHull(mp, idx);
    int [] idArray = idx.toArray();
    Point [] ptArray = mp.toArray();
    // Fill the intersection area.
    noStroke();
    fill(255, 100);
    beginShape();
    for (int i=0; i<idArray.length; i++) {
      Point p = ptArray[idArray[i]];
      vertex((float)p.x+cap.width, (float)p.y);
    }
    endShape(CLOSE);
    inter.release();
    idx.release();
    mp.release();
  }
  popStyle();
  image(cap, 0, 0);
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
  hierarchy.release();
}

void mousePressed() {
  saveFrame("data/contours.png");
}