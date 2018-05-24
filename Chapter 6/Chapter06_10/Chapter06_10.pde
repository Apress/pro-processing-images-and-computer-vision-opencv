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
BackgroundSubtractorKNN bkg;
// Foreground mask object
Mat fgMask;
int dispW, dispH;

void setup() {
  size(800, 600);
  dispW = width/2;
  dispH = height/2;
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, CAPW, CAPH);
  cap.start();
  img = new CVImage(dispW, dispH);
  bkg = Video.createBackgroundSubtractorKNN();
  fgMask = new Mat();
  // Background image
  back = loadImage("background.png");
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  PImage tmp = createImage(dispW, dispH, ARGB);
  // Resize the capture image
  tmp.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, tmp.width, tmp.height);
  img.copyTo(tmp);
  Mat capFrame = img.getBGR();
  bkg.apply(capFrame, fgMask);
  // Background image object
  Mat bkImage = new Mat();
  bkg.getBackgroundImage(bkImage);
  CVImage out = new CVImage(fgMask.cols(), fgMask.rows());
  // Display the original video capture image.
  image(tmp, 0, 0);
  out.copyTo(bkImage);
  // Display the background image.
  image(out, dispW, 0);
  out.copyTo(fgMask);
  // Display the foreground mask.
  image(out, 0, dispH);
  // Obtain the foreground image with the PImage
  // mask method.
  tmp.mask(out);
  // Display the forground image on top of
  // the static background.
  image(back, dispW, dispH);
  image(tmp, dispW, dispH);
  text(nf(round(frameRate), 2), 10, 20);
  capFrame.release();
}

void mousePressed() {
  saveFrame("data/back####.jpg");
}