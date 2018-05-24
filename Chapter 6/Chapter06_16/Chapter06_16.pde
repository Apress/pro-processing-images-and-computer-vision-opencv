// Display global motion direction.
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.optflow.Optflow;
import java.lang.System;

final int CNT = 2;
// Define motion history duration.
final double MHI_DURATION = 5;
final double MAX_TIME_DELTA = 0.5;
final double MIN_TIME_DELTA = 0.05;
Capture cap;
CVImage img;
Mat [] buf;
Mat mhi, mask, orient, silh;
int last;
double time0;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  last = 0;
  // Image buffer with two frames.
  buf = new Mat[CNT];
  for (int i=0; i<CNT; i++) {
    buf[i] = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  }
  // Motion history image
  mhi = Mat.zeros(cap.height, cap.width, CvType.CV_32FC1);
  // Threshold difference image
  silh = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  mask = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  orient = Mat.zeros(cap.height, cap.width, CvType.CV_32FC1);
  // Program start time
  time0 = System.nanoTime();
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
  // Get current time in seconds.
  double timestamp = (System.nanoTime() - time0)/1e9;
  // Compute difference with threshold.
  Core.absdiff(buf[idx1], buf[idx2], silh);
  Imgproc.threshold(silh, silh, 30, 255, Imgproc.THRESH_BINARY);
  // Update motion history image.
  Optflow.updateMotionHistory(silh, mhi, timestamp, MHI_DURATION);
  mhi.convertTo(mask, CvType.CV_8UC1, 
    255.0/MHI_DURATION, 
    (MHI_DURATION - timestamp)*255.0/MHI_DURATION);
  // Display motion history image in 8bit greyscale.
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(mask);
  image(img, 0, 0);
  image(out, cap.width, 0);
  // Compute overall motion gradient.
  Optflow.calcMotionGradient(mhi, mask, orient, 
    MAX_TIME_DELTA, MIN_TIME_DELTA, 3);
  // Calculate motion direction of whole frame.
  double angle = Optflow.calcGlobalOrientation(orient, mask, 
    mhi, timestamp, MHI_DURATION);
  // Skip cases with too little motion.
  double count = Core.norm(silh, Core.NORM_L1);
  if (count > (cap.width*cap.height*0.1)) {
    pushStyle();
    noFill();
    stroke(255, 0, 0);
    float radius = min(cap.width, cap.height)/2.0;
    ellipse(cap.width/2+cap.width, cap.height/2, radius*2, radius*2);
    stroke(0, 0, 255);
    // Draw the main direction of motion.
    line(cap.width/2+cap.width, cap.height/2, 
      cap.width/2+cap.width+radius*cos(radians((float)angle)), 
      cap.height/2+radius*sin(radians((float)angle)));
    popStyle();
  }
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  grey.release();
}

void mousePressed() {
  saveFrame("data/hist####.jpg");
}