import org.opencv.core.*;

PImage img;
CVImage cv;

void setup() {
  size(1200, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  img = loadImage("hongkong.png");
  cv = new CVImage(img.width, img.height);
  noLoop();
}

void draw() {
  background(0);
  cv.copyTo(img);
  Mat mat = cv.getBGR();
  Core.flip(mat, mat, -1);
  cv.copyTo(mat);
  image(img, 0, 0);
  image(cv, img.width, 0);
  mat.release();
  saveFrame("data/flip.png");
}