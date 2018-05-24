// 3D effect
import processing.video.*;

final int FPS = 24;
final int CAPW = 640;
final int CAPH = 480;

Capture cap;
PImage [] img;
PShape [] shp;
int idx;
float angle;
int dispW, dispH;

void setup() {
  size(800, 600, P3D);
  cap = new Capture(this, CAPW, CAPH, FPS);
  cap.start();
  idx = 0;
  angle = 0;
  frameRate(FPS);
  // Keep the 24 frames in each img array member
  img = new PImage[FPS];
  // Keep the 24 images in a separate PShape
  shp = new PShape[FPS];
  dispW = cap.width;
  dispH = cap.height;
  for (int i=0; i<FPS; i++) {
    img[i] = createImage(dispW, dispH, ARGB);
    shp[i] = createShape(RECT, 0, 0, dispW, dispH);
    shp[i].setStroke(false);
    shp[i].setFill(color(255, 255, 255, 80));
    shp[i].setTint(color(255, 255, 255, 80));
    shp[i].setTexture(img[i]);
  }
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  lights();
  cap.read();
  // Copy the latest capture image into the 
  // array member with index - idx
  img[idx].copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img[idx].width, img[idx].height);
  pushMatrix();
  translate(width/2, height/2, -480);
  rotateY(radians(angle));
  translate(-dispW/2, -dispH/2, -480);
  displayAll();
  popMatrix();
  // Loop through the array with the idx
  idx++;
  idx %= FPS;
  angle += 0.5;
  angle %= 360;
  text(nf(round(frameRate), 2), 10, 20);
}

void displayAll() {
  // Always display the first frame of 
  // index - idx
  pushMatrix();
  int i = idx - FPS + 1;
  if (i < 0) 
    i += FPS;
  for (int j=0; j<FPS; j++) {
    shape(shp[i], 0, 0);
    i++;
    i %= FPS;
    translate(0, 0, 40);
  }
  popMatrix();
}

void mousePressed() {
  saveFrame("data/test####.png");
}