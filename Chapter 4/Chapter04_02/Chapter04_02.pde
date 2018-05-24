import org.opencv.core.*;
import org.opencv.imgproc.*;

CVImage cvout;
Mat in;
PImage img;
Point ctr;
float angle;

void setup() {
  size(1200, 600);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  img = loadImage("hongkong.png");
  CVImage cvin = new CVImage(img.width, img.height);
  cvout = new CVImage(cvin.width, cvin.height);
  cvin.copyTo(img);
  in = cvin.getBGR();
  ctr = new Point(img.width/2, img.height/2);
  angle = 0;
  frameRate(30);
}

void draw() {
  //  background(0);
  Mat rot = Imgproc.getRotationMatrix2D(ctr, angle, 1.0);
  Mat out = new Mat(in.size(), in.type());
  Imgproc.warpAffine(in, out, rot, out.size());
  cvout.copyTo(out);
  tint(255, 255);
  image(img, 0, 0);
  tint(255, 20);
  image(cvout, img.width, 0);
  angle += 0.5;
  angle %= 360;
  out.release();
  rot.release();
}

void mousePressed() {
  saveFrame("data/rotation.png");
}