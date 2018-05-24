// Greyscale image
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import cvimage.*;

Capture cap;
CVImage img;

void setup() {
  size(1280, 480);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  smooth();
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
  img.copyTo(grey);
  image(cap, 0, 0);
  image(img, cap.width, 0);
  grey.release();
}