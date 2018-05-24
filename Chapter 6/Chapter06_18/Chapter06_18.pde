// Motion history with motion segment
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.optflow.Optflow;
import java.lang.System;
import java.util.ArrayList;

final int CNT = 2;
// Minimum region area to display
final float MIN_AREA = 300;
// Motion history duration
final double MHI_DURATION = 3;
final double MAX_TIME_DELTA = 0.5;
final double MIN_TIME_DELTA = 0.05;

Capture cap;
CVImage img;
Mat [] buf;
Mat mhi, mask, orient, segMask, silh;
int last;
double time0, timestamp;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  last = 0;
  buf = new Mat[CNT];
  for (int i=0; i<CNT; i++) {
    buf[i] = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  }
  // Motion history image
  mhi = Mat.zeros(cap.height, cap.width, CvType.CV_32FC1);
  mask = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  orient = Mat.zeros(cap.height, cap.width, CvType.CV_32FC1);
  segMask = Mat.zeros(cap.height, cap.width, CvType.CV_32FC1);
  // Threshold difference image
  silh = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  // Program start time
  time0 = System.nanoTime();
  timestamp = 0;
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
  grey.copyTo(buf[last]);
  int idx1, idx2;
  idx1 = last;
  idx2 = (last + 1) % buf.length;
  last = idx2;
  silh = buf[idx2];
  double timestamp = (System.nanoTime() - time0)/1e9;
  // Create threshold difference image.
  Core.absdiff(buf[idx1], buf[idx2], silh);
  Imgproc.threshold(silh, silh, 30, 255, Imgproc.THRESH_BINARY);
  // Update motion history image.
  Optflow.updateMotionHistory(silh, mhi, timestamp, MHI_DURATION);
  // Convert motion history to 8bit image.
  mhi.convertTo(mask, CvType.CV_8UC1, 
    255.0/MHI_DURATION, 
    (MHI_DURATION - timestamp)*255.0/MHI_DURATION);
  // Display motion history image in greyscale.
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(mask);
  // Calculate overall motion gradient.
  Optflow.calcMotionGradient(mhi, mask, orient, 
    MAX_TIME_DELTA, MIN_TIME_DELTA, 3);
  // Segment general motion into different regions.
  MatOfRect regions = new MatOfRect();
  Optflow.segmentMotion(mhi, segMask, regions, 
    timestamp, MAX_TIME_DELTA);
  image(img, 0, 0);
  image(out, cap.width, 0);
  // Plot individual motion areas.
  plotMotion(regions.toArray());
  pushStyle();
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  grey.release();
  regions.release();
}

void plotMotion(Rect [] rs) {
  pushStyle();
  fill(0, 0, 255, 80);
  stroke(255, 255, 0);
  for (Rect r : rs) {
    // Skip regions of small area.
    float area = r.width*r.height;
    if (area < MIN_AREA) 
      continue;
    // Obtain submatrices from motion images.
    Mat silh_roi = silh.submat(r);
    Mat mhi_roi = mhi.submat(r);
    Mat orient_roi = orient.submat(r);
    Mat mask_roi = mask.submat(r);
    // Calculate motion direction of that region.
    double angle = Optflow.calcGlobalOrientation(orient_roi, 
      mask_roi, mhi_roi, timestamp, MHI_DURATION);
    // Skip regions with little motion.
    double count = Core.norm(silh_roi, Core.NORM_L1);
    if (count < (r.width*r.height*0.05)) 
      continue;
    PVector center = new PVector(r.x + r.width/2, 
      r.y + r.height/2);
    float radius = min(r.width, r.height)/2.0;
    ellipse(center.x, center.y, radius*2, radius*2);
    line(center.x, center.y, 
      center.x+radius*cos(radians((float)angle)), 
      center.y+radius*sin(radians((float)angle)));
    silh_roi.release();
    mhi_roi.release();
    orient_roi.release();
    mask_roi.release();
  }
  popStyle();
}

void mousePressed() {
  saveFrame("data/hist####.jpg");
}