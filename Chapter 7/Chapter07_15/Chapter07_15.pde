// People detection
import processing.video.*;
import org.opencv.core.*;
import org.opencv.objdetect.HOGDescriptor;

// Detection size
final int W = 320, H = 240;
Capture cap;
CVImage img;
// People detection descriptor
HOGDescriptor hog;
float ratio;

void setup() {
  size(640, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width, height);
  cap.start();
  img = new CVImage(W, H);
  // Initialize the descriptor.
  hog = new HOGDescriptor();
  // User the people detector.
  hog.setSVMDetector(HOGDescriptor.getDefaultPeopleDetector());
  ratio = float(width)/W;
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  img.copyTo();
  image(cap, 0, 0);
  Mat grey = img.getGrey();
  MatOfRect found = new MatOfRect();
  MatOfDouble weight = new MatOfDouble();
  // Perform the people detection.
  hog.detectMultiScale(grey, found, weight);
  Rect [] people = found.toArray();
  pushStyle();
  fill(255, 255, 0, 100);
  stroke(255);
  // Draw the bounding boxes of people detected.
  for (Rect r : people) { 
    rect(r.x*ratio, r.y*ratio, r.width*ratio, r.height*ratio);
  }
  grey.release();
  found.release();
  weight.release();
  noStroke();
  fill(0);
  text(nf(round(frameRate), 2, 0), 10, 20);
  popStyle();
}

void mousePressed() {
  saveFrame("data/people####.jpg");
}