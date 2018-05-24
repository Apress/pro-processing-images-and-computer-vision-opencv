// Face detection
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
import org.opencv.objdetect.CascadeClassifier;

// Detection image size
final int W = 320, H = 240;
Capture cap;
CVImage img;
CascadeClassifier face;
// Ratio between capture size and 
// detection size
float ratio;
KFilter kalman;

void setup() {
  size(640, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width, height);
  cap.start();
  img = new CVImage(W, H);
  // Load the trained face information.
  face = new CascadeClassifier(dataPath("haarcascade_frontalface_default.xml"));
  ratio = float(width)/W;
  kalman = new KFilter(8, 4);
  frameRate(30);
  kalman.initFilter(30);
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
  // Perform face detction. Detection 
  // result is in the faces.
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(grey, faces);
  Rect [] facesArr = faces.toArray();
  pushStyle();
  fill(255, 255, 0, 100);
  stroke(255);
  // Draw only one single face.
  if (facesArr.length == 1) {
    Rect r = facesArr[0];
    float [] tmp = kalman.updateFilter(r.x, r.y, r.width, r.height).toArray();
    rect(tmp[0]*ratio, tmp[1]*ratio, tmp[2]*ratio, tmp[3]*ratio);
  }
  grey.release();
  faces.release();
  noStroke();
  fill(0);
  text(nf(round(frameRate), 2, 0), 10, 20);
  popStyle();
}

void mousePressed() {
  saveFrame("data/face####.jpg");
}