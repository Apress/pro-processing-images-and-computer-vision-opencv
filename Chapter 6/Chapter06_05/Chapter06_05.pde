// Difference between video and background
import processing.video.*;

final int CAPW = 640;
final int CAPH = 480;

Capture cap;
PImage back, img, diff;
int dispW, dispH;

void setup() {
  size(800, 600);
  cap = new Capture(this, CAPW, CAPH);
  cap.start();
  dispW = width/2;
  dispH = height/2;
  back = createImage(dispW, dispH, ARGB);
  img = createImage(dispW, dispH, ARGB);
  diff = createImage(dispW, dispH, ARGB);
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  // Get the difference image.
  diff.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  diff.filter(GRAY);
  diff.blend(back, 0, 0, back.width, back.height, 
    0, 0, diff.width, diff.height, DIFFERENCE);
  // Obtain the threshold binary image.
  img.copy(diff, 0, 0, diff.width, diff.height, 
    0, 0, img.width, img.height);
  img.filter(THRESHOLD, 0.4);
  image(cap, 0, 0, dispW, dispH);
  image(back, dispW, 0, dispW, dispH);
  image(diff, 0, dispH, dispW, dispH);
  image(img, dispW, dispH, dispW, dispH);
  text(nf(round(frameRate), 2), 10, 20);
}

void mousePressed() {
  // Update the background image.
  back.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, back.width, back.height);
  back.filter(GRAY);
}

void keyPressed() {
  saveFrame("data/differ####.jpg");
}