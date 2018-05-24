// Gestural interaction demo
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.optflow.Optflow;
import java.lang.System;

final int CNT = 2;
// Define motion history duration.
final double MHI_DURATION = 3;
final double MAX_TIME_DELTA = 0.5;
final double MIN_TIME_DELTA = 0.05;
Capture cap;
CVImage img;
Mat [] buf;
Mat mhi, mask, orient, silh;
int last;
double time0;
float rot, vel, drag;

void setup() {
  // Three dimensional scene
  size(640, 480, P3D);
  background(0);
  // Disable depth test.
  hint(DISABLE_DEPTH_TEST);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width, height);
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
  // Rotation of the cube in Y direction
  rot = 0;
  // Rotation velocity
  vel = 0;
  // Damping force
  drag = 0.9;
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
  // Compute overall motion gradient.
  Optflow.calcMotionGradient(mhi, mask, orient, 
    MAX_TIME_DELTA, MIN_TIME_DELTA, 3);
  // Calculate motion direction of whole frame.
  double angle = Optflow.calcGlobalOrientation(orient, mask, 
    mhi, timestamp, MHI_DURATION);
  // Skip cases with too little motion.
  double count = Core.norm(silh, Core.NORM_L1);
  if (count > (cap.width*cap.height*0.1)) {
    // Moving to the right
    if (angle < 10 || (360 - angle) < 10) {
      vel -= 0.02;
      // Moving to the left
    } else if (abs((float)angle-180) < 20) {
      vel += 0.02;
    }
  }
  // Slow down the velocity
  vel *= drag;
  // Update the rotation angle
  rot += vel;
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  // Draw the cube.
  pushMatrix();
  pushStyle();
  fill(255, 80);
  stroke(255);
  translate(cap.width/2, cap.height/2, 0);
  rotateY(rot);
  box(200);
  popStyle();
  popMatrix();
  grey.release();
}

void mousePressed() {
  saveFrame("data/hist####.jpg");
}