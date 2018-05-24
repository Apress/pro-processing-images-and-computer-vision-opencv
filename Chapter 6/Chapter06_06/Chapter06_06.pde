// Difference between consecutive frames
import processing.video.*;

final int CNT = 2;
// Capture size
final int CAPW = 640;
final int CAPH = 480;

Capture cap;
// Keep two frames to use alternately with
// array indices (prev, curr).
PImage [] img;
int prev, curr;
// Display image size
int dispW, dispH;

void setup() {
  size(800, 600);
  dispW = width/2;
  dispH = height/2;
  cap = new Capture(this, CAPW, CAPH);
  cap.start();
  img = new PImage[CNT];
  for (int i=0; i<img.length; i++) {
    img[i] = createImage(dispW, dispH, ARGB);
  }
  prev = 0;
  curr = 1;
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  // Copy video image to current frame.
  img[curr].copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img[curr].width, img[curr].height);
  // Display current and previous frames.
  image(img[curr], 0, 0, dispW, dispH);
  image(img[prev], dispW, 0, dispW, dispH);
  PImage tmp = createImage(dispW, dispH, ARGB);
  arrayCopy(img[curr].pixels, tmp.pixels);
  tmp.updatePixels();
  // Create the difference image.
  tmp.blend(img[prev], 0, 0, img[prev].width, img[prev].height, 
    0, 0, tmp.width, tmp.height, DIFFERENCE);
  tmp.filter(GRAY);
  image(tmp, 0, dispH, dispW, dispH);
  // Convert the difference image to binary.
  tmp.filter(THRESHOLD, 0.3);
  image(tmp, dispW, dispH, dispW, dispH);
  text(nf(round(frameRate), 2), 10, 20);
  // Swap the two array indices.
  int temp = prev;
  prev = curr;
  curr = temp;
}

void mousePressed() {
  saveFrame("data/diff####.jpg");
}