// Display threshold difference image.
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;

final int CNT = 2;
Capture cap;
CVImage img;
Mat [] buf;
Mat silh;
int last;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  last = 0;
  // Two frames buffer for comparison
  buf = new Mat[CNT];
  for (int i=0; i<CNT; i++) {
    buf[i] = Mat.zeros(cap.height, cap.width, 
      CvType.CV_8UC1);
  }
  // Threshold difference image
  silh = new Mat(cap.height, cap.width, CvType.CV_8UC1, 
    Scalar.all(0));
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
  // Create the threshold difference image between two frames.
  Core.absdiff(buf[idx1], buf[idx2], silh);
  Imgproc.threshold(silh, silh, 30, 255, Imgproc.THRESH_BINARY);
  CVImage out = new CVImage(cap.width, cap.height);
  out.copyTo(silh);
  image(img, 0, 0);
  image(out, cap.width, 0);
  text(nf(round(frameRate), 2), 10, 20);
  grey.release();
}

void mousePressed() {
  saveFrame("data/hist####.jpg");
}