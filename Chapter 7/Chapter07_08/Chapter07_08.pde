// Keypoint descriptor
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.features2d.FeatureDetector;

Capture cap;
CVImage img;
FeatureDetector fd;
DescriptorExtractor de;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  //fd = FeatureDetector.create(FeatureDetector.AKAZE);
  fd = FeatureDetector.create(FeatureDetector.ORB);
  // Create the instance for the descriptor
  //de = DescriptorExtractor.create(DescriptorExtractor.AKAZE);
  de = DescriptorExtractor.create(DescriptorExtractor.ORB);
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
  image(cap, 0, 0);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(grey);
  tint(255, 200);
  image(out, cap.width, 0);
  noTint();
  MatOfKeyPoint pt = new MatOfKeyPoint();
  fd.detect(grey, pt);
  Mat desc = new Mat();
  // Compute the descriptor from grey and pt.
  de.compute(grey, pt, desc);
  pushStyle();
  noFill();
  stroke(255, 200, 0);
  KeyPoint [] kps = pt.toArray();
  for (KeyPoint kp : kps) {
    float x = (float)kp.pt.x;
    float y = (float)kp.pt.y;
    ellipse(x+cap.width, y, kp.size, kp.size);
  }
  popStyle();
  pt.release();
  grey.release();
  desc.release();
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
}