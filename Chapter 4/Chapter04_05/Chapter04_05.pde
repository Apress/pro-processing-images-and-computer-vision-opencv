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
  
  MatOfPoint2f srcMat = new MatOfPoint2f(new Point(0, 0), 
    new Point(img.width-1, 0), 
    new Point(img.width-1, img.height-1));
  MatOfPoint2f dstMat = new MatOfPoint2f(new Point(50, 50), 
    new Point(img.width-100, 100), 
    new Point(img.width-50, img.height-100));

  Mat affine = Imgproc.getAffineTransform(srcMat, dstMat);
  Mat in = cv.getBGR();
  Mat out = new Mat(in.size(), in.type());
  Imgproc.warpAffine(in, out, affine, out.size());
  cv.copyTo(out);
  image(img, 0, 0);
  image(cv, img.width, 0);
  in.release();
  out.release();
  affine.release();
  saveFrame("data/affine.png");
}