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
  background(250);
  cap.read();
  img.copyTo(cap);
  Mat tmp1 = img.getGrey();
  Mat tmp2 = new Mat();
  Imgproc.blur(tmp1, tmp2, new Size(3, 3));
  Imgproc.Canny(tmp2, tmp1, 80, 160);
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  image(cap, 0, 0);
  pushStyle();
  stroke(50);
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) {
    MatOfPoint mp = it.next();
    Point [] pts = mp.toArray();
    boolean inside = true;
    if (mouseX < cap.width) {
      noFill();
    } else {
      int mx = constrain(mouseX-cap.width, 0, cap.width-1);
      int my = constrain(mouseY, 0, cap.height-1);
      double result = Imgproc.pointPolygonTest(new MatOfPoint2f(pts), 
        new Point(mx, my), false);
      if (result > 0) {
        fill(255, 0, 0);
      } else {
        noFill();
      }
    }
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
  hierarchy.release();
}

void mousePressed() {
  saveFrame("data/contours.png");
}