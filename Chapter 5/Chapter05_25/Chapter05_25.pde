import java.util.ArrayList;
import java.util.Iterator;

CVImage cv;
PImage img;

void setup() {
  size(1200, 600);
  background(50);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  img = loadImage("chinese.png");
  cv = new CVImage(img.width, img.height);
  noLoop();
}

void draw() {
  cv.copyTo(img);
  Mat tmp1 = cv.getGrey();
  Mat tmp2 = new Mat();
  Imgproc.blur(tmp1, tmp2, new Size(3, 3));
  Imgproc.Canny(tmp2, tmp1, 100, 200);
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  image(img, 0, 0);
  pushStyle();
  noFill();
  stroke(250);
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) {
    MatOfInt hull = new MatOfInt();
    MatOfPoint mPt = it.next();
    Point [] pts = mPt.toArray();
    Imgproc.convexHull(mPt, hull);
    int [] indices = hull.toArray();
    beginShape();
    for (int i=0; i<indices.length; i++) {
      vertex((float)pts[indices[i]].x+img.width, (float)pts[indices[i]].y);
    }
    endShape(CLOSE);
    hull.release();
    mPt.release();
  }
  popStyle();
  tmp1.release();
  tmp2.release();
  saveFrame("data/convex.png");
}