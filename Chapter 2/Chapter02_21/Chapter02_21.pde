import processing.video.*;

Capture cap;
CVImage img;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, width, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  frameRate(30);
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copyTo(cap);
  Mat grey = img.getGrey();
  img.copyTo(grey);
  image(img, 0, 0);
  text(nf(round(frameRate), 2), 10, 20);
  grey.release();
}

void mousePressed() {
  img.save(dataPath("screenshot.jpg"));
}