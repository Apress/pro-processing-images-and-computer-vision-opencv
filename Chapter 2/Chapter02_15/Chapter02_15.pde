import org.opencv.core.*;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  noLoop();
}

void draw() {
  background(0);
  Mat m1 = new Mat(new Size(4, 3), CvType.CV_8UC4, new Scalar(100, 200, 80, 255));
  byte [] data1 = new byte[m1.channels()];
  byte [] data2 = new byte[m1.channels()];
  m1.get(1, 1, data1);
  data2[0] = data1[3];
  data2[1] = data1[2];
  data2[2] = data1[1];
  data2[3] = data1[0];
  m1.put(1, 1, data2);
  printArray(m1.get(1, 1));
  m1.put(2, 2, 123, 234, 200, 100);
  printArray(m1.get(2, 2));
}