// Difference between 2 consecutive frames
import processing.video.*;
import java.util.ArrayList;
import java.util.Iterator;

final int CNT = 2;
// Capture size
final int CAPW = 640;
final int CAPH = 480;
// Minimum bounding box area
final float MINAREA = 200.0;

Capture cap;
// Previous and current frames in Mat format
Mat [] frames;
int prev, curr;
CVImage img;
// Display size
int dispW, dispH;

void setup() {
  size(800, 600);
  dispW = width/2;
  dispH = height/2;
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, CAPW, CAPH);
  cap.start();
  img = new CVImage(dispW, dispH);
  frames = new Mat[CNT];
  for (int i=0; i<CNT; i++) {
    frames[i] = new Mat(img.height, img.width, 
      CvType.CV_8UC1, Scalar.all(0));
  }
  prev = 0;
  curr = 1;
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  PImage tmp0 = createImage(dispW, dispH, ARGB);
  tmp0.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, tmp0.width, tmp0.height);
  // Display current frame.
  image(tmp0, 0, 0);
  img.copyTo(tmp0);
  frames[curr] = img.getGrey();
  CVImage out = new CVImage(dispW, dispH);
  out.copyTo(frames[prev]);
  // Display previous frame.
  image(out, dispW, 0, dispW, dispH);
  Mat tmp1 = new Mat();
  Mat tmp2 = new Mat();
  // Difference between previous and current frames
  Core.absdiff(frames[prev], frames[curr], tmp1);
  Imgproc.threshold(tmp1, tmp2, 90, 255, Imgproc.THRESH_BINARY);
  out.copyTo(tmp2);
  // Display threshold difference image.
  image(out, 0, dispH, dispW, dispH);
  // Obtain contours of the difference binary image
  ArrayList<MatOfPoint> contours = new ArrayList<MatOfPoint>();
  Mat hierarchy = new Mat();
  Imgproc.findContours(tmp2, contours, hierarchy, 
    Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE);
  Iterator<MatOfPoint> it = contours.iterator();
  pushStyle();
  fill(255, 180);
  noStroke();
  while (it.hasNext()) {
    MatOfPoint cont = it.next();
    // Draw each bounding box
    Rect rct = Imgproc.boundingRect(cont);
    float area = (float)(rct.width * rct.height);
    if (area < MINAREA)
      continue;
    rect((float)rct.x+dispW, (float)rct.y+dispH, 
      (float)rct.width, (float)rct.height);
  }
  popStyle();
  text(nf(round(frameRate), 2), 10, 20);
  int temp = prev;
  prev = curr;
  curr = temp;
  hierarchy.release();
  tmp1.release();
  tmp2.release();
}

void mousePressed() {
  saveFrame("data/box####.jpg");
}