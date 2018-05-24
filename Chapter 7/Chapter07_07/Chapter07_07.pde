// Features detection
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.features2d.FeatureDetector;

final float MIN_RESP = 0.000;
Capture cap;
CVImage img;
FeatureDetector fd;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  // Create the instance of the class.
  fd = FeatureDetector.create(FeatureDetector.ORB);
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
  MatOfKeyPoint pt = new MatOfKeyPoint();
  // Detect keypoints from the image.
  fd.detect(grey, pt);
  image(cap, 0, 0);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(grey);
  tint(255, 100);
  image(out, cap.width, 0);
  noTint();
  pushStyle();
  noFill();
  stroke(255, 200, 0);
  KeyPoint [] kps = pt.toArray();
  for (KeyPoint kp : kps) {
    // Skip the keypoints that are less likely.
    if (kp.response < MIN_RESP) 
      continue;
    float x1 = (float)kp.pt.x;
    float y1 = (float)kp.pt.y;
    float x2 = x1 + kp.size*cos(radians(kp.angle))/2;
    float y2 = y1 + kp.size*sin(radians(kp.angle))/2;
    // size is the diameter of neighborhood.
    ellipse(x1+cap.width, y1, kp.size, kp.size);
    // Draw also the orientation direction.
    line(x1+cap.width, y1, x2+cap.width, y2);
  }  
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  grey.release();
  pt.release();
}

void mousePressed() {
  saveFrame("data/feat####.jpg");
}