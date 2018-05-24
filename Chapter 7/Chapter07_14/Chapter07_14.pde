// Smile detection
import processing.video.*;

import org.opencv.core.*;
import org.opencv.objdetect.CascadeClassifier;

// Face detection size
final int W = 320, H = 240;
Capture cap;
CVImage img;
// Two classifiers, one for face, one for smile
CascadeClassifier face, smile;
float ratio;

void setup() {
  size(640, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width, height);
  cap.start();
  img = new CVImage(W, H);
  face = new CascadeClassifier(dataPath("haarcascade_frontalface_default.xml"));
  smile = new CascadeClassifier(dataPath("haarcascade_smile.xml"));
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
  noStroke();
  image(cap, 0, 0);
  Mat grey = img.getGrey();
  MatOfRect faces = new MatOfRect();
  // Detect the faces first.
  face.detectMultiScale(grey, faces, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(60, 60), new Size(200, 200));
  Rect [] facesArr = faces.toArray();
  pushStyle();
  for (Rect r : facesArr) {
    fill(255, 255, 0, 100);
    stroke(255, 0, 0);
    float cx = r.x + r.width/2.0;
    float cy = r.y + r.height/2.0;
    ellipse(cx*ratio, cy*ratio, 
      r.width*ratio, r.height*ratio);
    // For each face, obtain the image within the bounding box.
    Mat fa = grey.submat(r);
    MatOfRect m = new MatOfRect();
    // Detect smiling expression.
    smile.detectMultiScale(fa, m, 1.2, 25, 
      Objdetect.CASCADE_SCALE_IMAGE, 
      new Size(30, 30), new Size(80, 80));
    Rect [] mArr = m.toArray();
    stroke(0, 0, 255);
    noFill();
    // Draw the line of the mouth.
    for (Rect sm : mArr) {
      float yy = sm.y+r.y+sm.height/2.0;
      line((sm.x+r.x)*ratio, yy*ratio, 
        (sm.x+r.x+sm.width)*ratio, yy*ratio);
    }
    fa.release();
    m.release();
  }
  noStroke();
  fill(0);
  text(nf(round(frameRate), 2, 0), 10, 20);
  popStyle();
  grey.release();
  faces.release();
}

void mousePressed() {
  saveFrame("data/smile####.jpg");
}