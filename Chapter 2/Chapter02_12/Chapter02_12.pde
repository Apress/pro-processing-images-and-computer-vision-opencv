import org.opencv.core.*;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  noLoop();
}

void draw() {
  background(0);
  Mat m1 = new Mat();
  println(m1.dump());
  Mat m2 = new Mat(3, 4, CvType.CV_8UC1, Scalar.all(0));
  println(m2.dump());
  Mat m3 = new Mat(3, 4, CvType.CV_8UC3, Scalar.all(255));
  println(m3.dump());
  Mat m4 = new Mat(new Size(4, 3), CvType.CV_8UC3, new Scalar(0, 255, 0));
  println(m4.dump());
}