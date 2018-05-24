import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.*;

Capture cap;
CVImage img, out;
int capW, capH;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  capW = width/2;
  capH = height;
  cap = new Capture(this, capW, capH);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  out = new CVImage(cap.width, cap.height);
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copyTo(cap);
  Mat linear = img.getBGR();
  Mat polar = new Mat();
  Point ctr = new Point(cap.width/2, cap.height/2);
  double radius = min(cap.width, cap.height)/2.0;
  Imgproc.linearPolar(linear, polar, ctr, radius, 
    Imgproc.INTER_LINEAR+Imgproc.WARP_FILL_OUTLIERS);
  out.copyTo(polar);
  image(cap, 0, 0);
  image(out, cap.width, 0);
  linear.release();
  polar.release();
}

void mousePressed() {
  saveFrame("data/polar.png");
}