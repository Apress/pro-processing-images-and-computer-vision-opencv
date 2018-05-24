// Feature points detection
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;

Capture cap;
CVImage img;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  smooth();
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  img.copyTo();
  Mat grey = img.getGrey();
  MatOfPoint corners = new MatOfPoint();
  // Identify the good feature points.
  Imgproc.goodFeaturesToTrack(grey, corners, 
    100, 0.01, 10);
  Point [] points = corners.toArray();
  pushStyle();
  noStroke();
  // Draw each feature point according to its
  // original color of the pixel.
  for (Point p : points) {
    int x = (int)constrain((float)p.x, 0, cap.width-1);
    int y = (int)constrain((float)p.y, 0, cap.height-1);
    color c = cap.pixels[y*cap.width+x];
    fill(c);
    ellipse(x+cap.width, y, 10, 10);
  }
  image(img, 0, 0);
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  grey.release();
  corners.release();
}

void mousePressed() {
  saveFrame("data/point####.jpg");
}