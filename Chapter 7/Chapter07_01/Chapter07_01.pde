// Harris corner detection
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;

// Threshold value for a corner
final int THRESH = 140;
Capture cap;
CVImage img;
// Scale down the image for detection.
float scaling;
int w, h;

void setup() {
  size(640, 480);
  background(0);
  scaling = 10;
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width, height);
  cap.start();
  w = floor(cap.width/scaling);
  h = floor(cap.height/scaling);
  img = new CVImage(w, h);
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
  // Output matrix of corner information
  Mat corners = Mat.zeros(grey.size(), CvType.CV_32FC1);
  Imgproc.cornerHarris(grey, corners, 2, 3, 0.04, 
    Core.BORDER_DEFAULT);
  // Normalize the corner information matrix.
  Mat cor_norm = Mat.zeros(grey.size(), CvType.CV_8UC1);
  Core.normalize(corners, cor_norm, 0, 255, 
    Core.NORM_MINMAX, CvType.CV_8UC1);
  image(cap, 0, 0);
  pushStyle();
  noFill();
  stroke(255, 0, 0);
  strokeWeight(2);
  // Draw each corner with value greater than threshold.
  for (int y=0; y<cor_norm.rows(); y++) {
    for (int x=0; x<cor_norm.cols(); x++) {
      if (cor_norm.get(y, x)[0] < THRESH) 
        continue;
      ellipse(x*scaling, y*scaling, 10, 10);
    }
  }
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  grey.release();
  corners.release();
  cor_norm.release();
}

void mousePressed() {
  saveFrame("data/corner####.jpg");
}