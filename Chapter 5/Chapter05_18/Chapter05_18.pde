import processing.video.*;

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
  MatOfPoint3f circles = new MatOfPoint3f();
  Imgproc.HoughCircles(img.getGrey(), circles, Imgproc.HOUGH_GRADIENT, 1, img.height/10, 200, 20, 0, 0);
  Point3 [] points = circles.toArray();
  pushStyle();
  noStroke();
  for (Point3 p : points) {
    int x1 = constrain((int)p.x, 0, cap.width-1);
    int y1 = constrain((int)p.y, 0, cap.height-1);
    color col = cap.pixels[y1*cap.width+x1];
    fill(color(red(col), green(col), blue(col), 160));
    ellipse(x1+cap.width, y1, (float)p.z, (float)p.z);
  }
  popStyle();
  image(cap, 0, 0);
  text(nf(round(frameRate), 2), 10, 20);
  circles.release();
}

void mousePressed() {
  saveFrame("data/circles.png");
}