import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  Mat m = Mat.eye(3, 3, CvType.CV_8UC1);
  println("Content of the matrix m is:");
  println(m.dump());
}

void draw() {
  background(100, 100, 100);
}