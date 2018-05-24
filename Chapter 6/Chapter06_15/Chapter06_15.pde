// Display motion history image.
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.optflow.Optflow;
import java.lang.System;

final int CNT = 2;
// Motion history duration is 5 seconds.
final double MHI_DURATION = 5;
Capture cap;
CVImage img;
Mat [] buf;
Mat mhi, silh, mask;
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
  // Maintain two buffer frames.
  buf = new Mat[CNT];
  for (int i=0; i<CNT; i++) {
    buf[i] = Mat.zeros(cap.height, cap.width, 
      CvType.CV_8UC1);
  }
  // Initialize the threshold difference image.
  silh = new Mat(cap.height, cap.width, CvType.CV_8UC1, 
    Scalar.all(0));
  // Initialize motion history image.
  mhi = Mat.zeros(cap.height, cap.width, CvType.CV_32FC1);
  mask = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  // Store timestamp when program starts to run.
  time0 = System.nanoTime();
  
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
  // Get current timestamp in seconds.
  double timestamp = (System.nanoTime() - time0)/1e9;
  // Create binary threshold image from two frames.
  Core.absdiff(buf[idx1], buf[idx2], silh);
  Imgproc.threshold(silh, silh, 30, 255, Imgproc.THRESH_BINARY);
  // Update motion history image from the threshold.
  Optflow.updateMotionHistory(silh, mhi, timestamp, MHI_DURATION);
  mhi.convertTo(mask, CvType.CV_8UC1, 
    255.0/MHI_DURATION, 
    (MHI_DURATION - timestamp)*255.0/MHI_DURATION);
  // Display the greyscale motion history image.
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(mask);
  image(img, 0, 0);
  image(out, cap.width, 0);
  text(nf(round(frameRate), 2), 10, 20);
  grey.release();
}

void mousePressed() {
  saveFrame("data/hist####.jpg");
}