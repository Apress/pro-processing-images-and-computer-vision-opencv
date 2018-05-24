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
  Mat capFrame = img.getBGRA();
  bkg.apply(capFrame, fgMask);
  // Combine the video frame and foreground
  // mask to obtain the foreground image.
  Mat fgImage = new Mat();
  capFrame.copyTo(fgImage, fgMask);  
  CVImage out = new CVImage(fgMask.cols(), fgMask.rows());
  // Display the original video capture image.
  image(tmp, 0, 0);
  // Display the static background image.
  image(back, dispW, 0);
  out.copyTo(fgMask);
  // Display the foreground mask.
  image(out, 0, dispH);
  out.copyTo(fgImage);
  // Display the forground image on top of
  // the static background.
  image(back, dispW, dispH);
  image(out, dispW, dispH);
  text(nf(round(frameRate), 2), 10, 20);
  capFrame.release();
  fgImage.release();
}

void mousePressed() {
  saveFrame("data/back####.jpg");
}