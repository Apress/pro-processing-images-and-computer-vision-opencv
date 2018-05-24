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
  Imgproc.Canny(tmp2, tmp1, 80, 160);
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  image(cap, 0, 0);
  pushStyle();
  noStroke();
  Iterator<MatOfPoint> it = contours.iterator();
  while (it.hasNext()) {
    Rect r = Imgproc.boundingRect(it.next());
    int cx = (int)(r.x + r.width/2);
    int cy = (int)(r.y + r.height/2);
    cx = constrain(cx, 0, cap.width-1);
    cy = constrain(cy, 0, cap.height-1);
    color col = cap.pixels[cy*cap.width+cx];
    fill(color(red(col), green(col), blue(col), 200));
    rect((float)r.x+cap.width, (float)r.y, (float)r.width, (float)r.height);
  }
  popStyle();
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  tmp2.release();
}

void mousePressed() {
  saveFrame("data/contours.png");
}