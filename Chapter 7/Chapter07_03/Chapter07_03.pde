// Feature points detection with subpixel accuracy
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;

Capture cap;
CVImage img;
TermCriteria term;
int w, h;
float xRatio, yRatio;

void setup() {
  size(800, 600);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  w = 640;
  h = 480;
  xRatio = (float)width/w;
  yRatio = (float)height/h;
  cap = new Capture(this, w, h);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  term = new TermCriteria(TermCriteria.COUNT | TermCriteria.EPS, 
    20, 0.03);
  smooth();
}

void draw() {
  if (!cap.available()) 
    return;
  background(200);
  cap.read();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  img.copyTo();
  Mat grey = img.getGrey();
  MatOfPoint corners = new MatOfPoint();
  // Detect the initial feature points.
  Imgproc.goodFeaturesToTrack(grey, corners, 
    100, 0.01, 10);
  MatOfPoint2f c2 = new MatOfPoint2f(corners.toArray());
  Imgproc.cornerSubPix(grey, c2, 
    new Size(5, 5), 
    new Size(-1, -1), term);
  Point [] points = corners.toArray();
  pushStyle();
  noFill();
  stroke(100);
  // Display the original points.
  for (Point p : points) {
    ellipse((float)p.x*xRatio, (float)p.y*yRatio, 20, 20);
  }
  points = c2.toArray();
  stroke(0);
  // Display the more accurate points.
  for (Point p : points) {
    ellipse((float)p.x*xRatio, (float)p.y*yRatio, 20, 20);
  }
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  grey.release();
  corners.release();
  c2.release();
}

void mousePressed() {
  saveFrame("data/point####.jpg");
}