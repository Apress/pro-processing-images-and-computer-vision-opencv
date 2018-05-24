// Scrolling effect
import processing.video.*;

// Processing modes for the draw() function
public enum Mode {
  WAITING, RECORDING, PLAYING
}

final int FPS = 24;
Capture cap;
Mode mode;
PShape [] shp;
PImage [] img;
PShape strip;
int dispW, dispH;
int recFrame;
float px, vx;

void setup() {
  size(800, 600, P3D);
  background(0);
  cap = new Capture(this, 640, 480);
  cap.start();
  // Frame size of the film strip
  dispW = 160;
  dispH = 120;
  // Position and velocity of the film strip
  px = 0; 
  vx = 0;
  prepareShape();
  mode = Mode.WAITING;
  recFrame = 0;
  frameRate(FPS);
  noStroke();
  fill(255);
}

void prepareShape() {
  // Film strip shape
  strip = createShape(GROUP);
  // Keep 24 frames in the PImage array
  img = new PImage[FPS];
  int extra = ceil(width/dispW);
  // Keep 5 more frames to compensate for the 
  // continuous scrolling effect
  shp = new PShape[FPS+extra];
  for (int i=0; i<FPS; i++) {
    img[i] = createImage(dispW, dispH, ARGB);
    shp[i] = createShape(RECT, 0, 0, dispW, dispH);
    shp[i].setStroke(false);
    shp[i].setFill(color(255));
    shp[i].setTexture(img[i]);
    shp[i].translate(i*img[i].width, 0);
    strip.addChild(shp[i]);
  }
  // The 5 extra frames are the same as the 
  // first 5 ones.
  for (int i=FPS; i<shp.length; i++) {
    shp[i] = createShape(RECT, 0, 0, dispW, dispH);
    shp[i].setStroke(false);
    shp[i].setFill(color(255));
    int j = i % img.length;
    shp[i].setTexture(img[j]);
    shp[i].translate(i*img[j].width, 0);
    strip.addChild(shp[i]);
  }
}

void draw() {
  switch (mode) {
  case WAITING:
    waitFrame();
    break;
  case RECORDING:
    recordFrame();
    break;
  case PLAYING:
    playFrame();
    break;
  }
}

void waitFrame() {
  // Display to live webcam image while waiting
  if (!cap.available()) 
    return;
  cap.read();
  background(0);
  image(cap, (width-cap.width)/2, (height-cap.height)/2);
}

void recordFrame() {
  // Record each frame into the PImage array
  if (!cap.available()) 
    return;
  if (recFrame >= FPS) {
    mode = Mode.PLAYING;
    recFrame = 0;
    println("Finish recording");
    return;
  }
  cap.read();
  img[recFrame].copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img[recFrame].width, img[recFrame].height);
  int sw = 80;
  int sh = 60;
  int tx = recFrame % (width/sw);
  int ty = recFrame / (width/sw);
  image(img[recFrame], tx*sw, ty*sh, sw, sh);
  recFrame++;
}

void playFrame() {
  background(0);
  // Compute the scrolling speed
  vx = (width/2 - mouseX)*0.6;
  px += vx;
  // Check for 2 boundary conditions
  if (px < (width-strip.getWidth())) {
    px = width - strip.getWidth() - px;
  } else if (px > 0) {
    px = px - strip.getWidth() + width;
  }
  shape(strip, px, 250);
}

void mousePressed() {
  // Press mouse button to record
  if (mode != Mode.RECORDING) {
    mode = Mode.RECORDING;
    recFrame = 0;
    background(0);
    println("Start recording");
  }
}

void keyPressed() {
  saveFrame("data/scroll####.png");
}