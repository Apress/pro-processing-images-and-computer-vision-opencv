import org.opencv.core.*;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  noLoop();
}

void draw() {
  background(0);
  Mat m1 = new Mat(new Size(4, 3), CvType.CV_8UC3, new Scalar(0, 100, 0));
  println(m1.dump());
  println(m1.rows() + ", " + m1.cols());
  println(m1.width() + ", " + m1.height());
  println("Size: " + m1.size());
  println("Dimension: " + m1.dims());
  println("Number of elements: " + m1.total());
  println("Element size: " + m1.elemSize());
  println("Depth: " + m1.depth());
  println("Number of channels: " + m1.channels());
}