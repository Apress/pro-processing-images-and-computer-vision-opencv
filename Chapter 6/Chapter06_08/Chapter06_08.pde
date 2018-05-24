// Background subtraction
import processing.video.*;
import org.opencv.video.*;
import org.opencv.video.Video;

// Capture size
final int CAPW = 640;
final int CAPH = 480;

Capture cap;
CVImage img;
PImage back;
// OpenCV background subtractor
BackgroundSubtractorMOG2 bkg;
// Foreground mask
Mat fgMask;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, CAPW, CAPH);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  bkg = Video.createBackgroundSubtractorMOG2();
  fgMask = new Mat();
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copyTo(cap);
  Mat capFrame = img.getBGRA();
  bkg.apply(capFrame, fgMask); 
  CVImage out = new CVImage(fgMask.cols(), fgMask.rows());
  out.copyTo(fgMask);
  image(cap, 0, 0);
  // Display the foreground mask
  image(out, cap.width, 0);
  text(nf(round(frameRate), 2), 10, 20);
  capFrame.release();
}

void mousePressed() {
  saveFrame("data/back####.jpg");
}