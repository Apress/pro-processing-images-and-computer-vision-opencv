import org.opencv.core.*;
import org.opencv.imgproc.*;

PImage img;
CVImage cv;

void setup() {
  size(1200, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  img = loadImage("hongkong.png");
  cv = new CVImage(img.width, img.height);
  cv.copyTo(img);
  noLoop();
}

void draw() {
  background(0);
  Mat in = cv.getBGR();
  Mat out = new Mat(new Size(img.width*0.5, img.height*0.5), in.type());
  Imgproc.resize(in, out, out.size());
  CVImage small = new CVImage(out.cols(), out.rows());
  small.copyTo(out);
  image(img, 0, 0);
  tint(255, 100, 100);
  image(small, img.width, 0);
  tint(100, 100, 255);
  image(small, img.width, small.height);
  saveFrame("data/resize.png");
}