import org.opencv.core.*;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  noLoop();
}

void draw() {
  background(0);
  Mat m1 = new Mat(new Size(4, 3), CvType.CV_8UC4, new Scalar(100, 200, 80, 255));
  double [] result = m1.get(0, 0);
  printArray(result);
  byte [] data = new byte[m1.channels()];
  m1.get(2, 2, data);
  for (byte b : data) {
    int i = (b < 0) ? b + 256 : b;
    println(i);
  }
}