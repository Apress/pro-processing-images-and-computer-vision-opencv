import java.util.ArrayList;

CVImage cvimg;
PImage img;

void setup() {
  size(1200, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  img = loadImage("chinese.png");
  cvimg = new CVImage(img.width, img.height);
  noLoop();
}

void draw() {
  background(0);
  cvimg.copyTo(img);
  Mat tmp1 = new Mat();
  Imgproc.blur(cvimg.getGrey(), tmp1, new Size(3, 3));
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(tmp1, contours, hierarchy, 
    Imgproc.RETR_CCOMP, Imgproc.CHAIN_APPROX_SIMPLE);
  image(img, 0, 0);

  pushStyle();
  stroke(255);
  for (int i=0; i<contours.size(); i++) {
    Point [] pts = contours.get(i).toArray();
    int parent = (int)hierarchy.get(0, i)[3];
    // parent -1 implies it is the outer contour.
    if (parent == -1) {
      fill(200);
    } else {
      fill(100);
    }
    beginShape();
    for (Point p : pts) {
      vertex((float)p.x+img.width, (float)p.y);
    }
    endShape(CLOSE);
  }
  popStyle();
  tmp1.release();
  hierarchy.release();
  saveFrame("data/contours.png");
}