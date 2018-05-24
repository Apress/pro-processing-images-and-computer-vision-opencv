// Sparse optical flow
import processing.video.*;
import org.opencv.core.*;
import org.opencv.video.Video;
import org.opencv.imgproc.Imgproc;

final int CNT = 2;
// Threshold to recalculate the feature points
final int MIN_PTS = 20;
// Number of points to track
final int TRACK_PTS = 150;

Capture cap;
CVImage img;
TermCriteria term;
// Keep the old and new frames in greyscale.
Mat [] grey;
// Keep the old and new feature points.
MatOfPoint2f [] points;
// Keep the last index of the buffer.
int last;
// First run of the program
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
  // Initialize the image and keypoint buffers.
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
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  img.copyTo();
  if (first) {
    // Initialize feature points in first run.
    findFeatures(img.getGrey());
    first = false;
    return;
  }
  int idx1, idx2;
  idx1 = last;
  idx2 = (idx1 + 1) % grey.length;
  last = idx2;
  grey[idx2] = img.getGrey();
  // Keep status and error of running the
  // optical flow function.
  MatOfByte status = new MatOfByte();
  MatOfFloat err = new MatOfFloat();
  Video.calcOpticalFlowPyrLK(grey[idx1], grey[idx2], 
    points[idx1], points[idx2], status, err);
  Point [] pts = points[idx2].toArray();
  byte [] statArr = status.toArray();
  pushStyle();
  noStroke();
  int count = 0;
  for (int i=0; i<pts.length; i++) {
    // Skip error cases.
    if (statArr[i] == 0) 
      continue;
    int x = (int)constrain((float)pts[i].x, 0, cap.width-1);
    int y = (int)constrain((float)pts[i].y, 0, cap.height-1);
    color c = cap.pixels[y*cap.width+x];
    fill(c);
    ellipse(x+cap.width, y, 10, 10);
    count++;
  }
  // Re-initialize feature points when valid points
  // drop down to the threshold.
  if (count < MIN_PTS) 
    findFeatures(img.getGrey());
  image(img, 0, 0);
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  status.release();
  err.release();
}

void findFeatures(Mat g) {
  // Find feature points given the greyscale image g.
  int idx1, idx2;
  idx1 = last;
  idx2 = (idx1 + 1) % grey.length;
  last = idx2;
  grey[idx2] = g;
  MatOfPoint pt = new MatOfPoint();
  // Calculate feature points at pixel level.
  Imgproc.goodFeaturesToTrack(grey[idx2], pt, 
    TRACK_PTS, 0.01, 10);
  points[idx2] = new MatOfPoint2f(pt.toArray());
  // Recalculate feature points at subpixel level.
  Imgproc.cornerSubPix(grey[idx2], points[idx2], 
    new Size(10, 10), 
    new Size(-1, -1), term);
  grey[idx2].copyTo(grey[idx1]);
  points[idx2].copyTo(points[idx1]);
  pt.release();
}

void keyPressed() {
  if (keyCode == 32) {
    // Press SPACE to initialize feature points.
    findFeatures(img.getGrey());
  }
}

void mousePressed() {
  saveFrame("data/point####.jpg");
}