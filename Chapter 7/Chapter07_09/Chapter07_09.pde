// Features matching
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.features2d.FeatureDetector;

Capture cap;
CVImage img;
FeatureDetector fd;
DescriptorExtractor de;
// Two sets of keypoints: train, query
MatOfKeyPoint trainKp, queryKp;
// Two sets of descriptor: train, query
Mat trainDc, queryDc;
Mat grey;
// Keep if training started.
boolean trained;
// Keep the trained image.
PImage trainImg;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  trainImg = createImage(cap.width, cap.height, ARGB);
  fd = FeatureDetector.create(FeatureDetector.BRISK);
  de = DescriptorExtractor.create(DescriptorExtractor.BRISK);
  trainKp = new MatOfKeyPoint();
  queryKp = new MatOfKeyPoint();
  trainDc = new Mat();
  queryDc = new Mat();
  grey = Mat.zeros(cap.height, cap.width, CvType.CV_8UC1);
  trained = false;
  smooth();
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();

  if (trained) {
    image(trainImg, 0, 0);
    image(cap, trainImg.width, 0);
    img.copy(cap, 0, 0, cap.width, cap.height, 
      0, 0, img.width, img.height);
    img.copyTo();
    grey = img.getGrey();
    fd.detect(grey, queryKp);
    de.compute(grey, queryKp, queryDc);
    drawTrain();
    drawQuery();
  } else {
    image(cap, 0, 0);
    image(cap, cap.width, 0);
  }
  pushStyle();
  fill(0);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
}

void drawTrain() {
  // Draw the keypoints for the trained snapshot.
  pushStyle();
  noFill();
  stroke(255, 200, 0);
  KeyPoint [] kps = trainKp.toArray();
  for (KeyPoint kp : kps) {
    float x = (float)kp.pt.x;
    float y = (float)kp.pt.y;
    ellipse(x, y, kp.size, kp.size);
  }
  popStyle();
}

void drawQuery() {
  // Draw the keypoints for live query image.
  pushStyle();
  noFill();
  stroke(255, 200, 0);
  KeyPoint [] kps = queryKp.toArray();
  for (KeyPoint kp : kps) {
    float x = (float)kp.pt.x;
    float y = (float)kp.pt.y;
    ellipse(x+trainImg.width, y, kp.size, kp.size);
  }
  popStyle();
}

void mousePressed() {
  // Press mouse button to toggle training.
  if (!trained) {
    arrayCopy(cap.pixels, trainImg.pixels);
    trainImg.updatePixels();
    img.copy(trainImg, 0, 0, trainImg.width, trainImg.height, 
      0, 0, img.width, img.height);
    img.copyTo();
    grey = img.getGrey();
    fd.detect(grey, trainKp);
    de.compute(grey, trainKp, trainDc);
    trained = true;
  } else {
    trained = false;
  }
}

void keyPressed() {
  saveFrame("data/kp####.jpg");
}