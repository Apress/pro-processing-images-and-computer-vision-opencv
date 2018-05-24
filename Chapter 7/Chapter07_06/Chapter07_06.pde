// Optical flow drawing
import processing.video.*;
import org.opencv.core.*;
import org.opencv.video.Video;
import org.opencv.imgproc.Imgproc;

final int CNT = 2;
final int TRACK_PTS = 150;
final int MAX_DIST = 100;

Capture cap;
CVImage img;
TermCriteria term;
Mat [] grey;
MatOfPoint2f [] points;
int last;
boolean first;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  term = new TermCriteria(TermCriteria.COUNT | TermCriteria.EPS, 
    20, 0.03);
  // Initialize the buffers for the 2 images and 2 keypoint lists.
  grey = new Mat[CNT];
  points = new MatOfPoint2f[CNT];
  for (int i=0; i<CNT; i++) {
    grey[i] = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
    points[i] = new MatOfPoint2f();
  }
  last = 0;
  first = true;
  smooth();
}

void draw() {
  // Note that we do not clear the background.
  if (!cap.available()) 
    return;
  cap.read();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  img.copyTo();

  if (first) {
    findFeatures(img.getGrey());
    first = false;
    return;
  }
  int idx1, idx2;
  idx1 = last;
  idx2 = (idx1 + 1) % grey.length;
  last = idx2;
  grey[idx2] = img.getGrey();
  MatOfByte status = new MatOfByte();
  MatOfFloat err = new MatOfFloat();
  Video.calcOpticalFlowPyrLK(grey[idx1], grey[idx2], 
    points[idx1], points[idx2], status, err);
  Point [] pt2 = points[idx2].toArray();
  Point [] pt1 = points[idx1].toArray();
  byte [] statArr = status.toArray();
  PVector p1 = new PVector(0, 0);
  PVector p2 = new PVector(0, 0);
  pushStyle();
  noFill();
  for (int i=0; i<pt2.length; i++) {
    if (statArr[i] == 0) 
      continue;
    p1.x = (int)constrain((float)pt1[i].x, 0, cap.width-1);
    p1.y = (int)constrain((float)pt1[i].y, 0, cap.height-1);
    p2.x = (int)constrain((float)pt2[i].x, 0, cap.width-1);
    p2.y = (int)constrain((float)pt2[i].y, 0, cap.height-1);
    if (p1.dist(p2) > MAX_DIST) 
      continue;
    color c = cap.pixels[(int)p2.y*cap.width+(int)p2.x];
    stroke(red(c), green(c), blue(c), (int)random(100, 160));
    strokeWeight(random(3, 6));
    line(p1.x+cap.width, p1.y, p2.x+cap.width, p2.y);
    c = cap.pixels[(int)p1.y*cap.width+(int)p1.x];
    stroke(red(c), green(c), blue(c), (int)random(120, 240));
    strokeWeight(random(1, 4));
    line(p1.x+cap.width, p1.y, p2.x+cap.width, p2.y);
  }
  findFeatures(img.getGrey());
  image(img, 0, 0);
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  status.release();
  err.release();
}

void findFeatures(Mat g) {
  // Re-initialize the feature points.
  grey[last] = g;
  MatOfPoint pt = new MatOfPoint();
  Imgproc.goodFeaturesToTrack(grey[last], pt, 
    TRACK_PTS, 0.01, 10);
  points[last] = new MatOfPoint2f(pt.toArray());
  Imgproc.cornerSubPix(grey[last], points[last], 
    new Size(10, 10), 
    new Size(-1, -1), term);
  pt.release();
}

void mousePressed() {
  saveFrame("data/point####.jpg");
}