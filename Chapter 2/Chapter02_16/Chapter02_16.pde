import org.opencv.core.*;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  noLoop();
}

void draw() {
  background(0);
  Mat m1 = new Mat(new Size(3, 2), CvType.CV_8UC1);
  for (int r=0; r<m1.rows(); r++) {
    for (int c=0; c<m1.cols(); c++) {
      m1.put(r, c, floor(random(100)));
    }
  }
  println(m1.dump());
  byte [] data = new byte[m1.rows()*m1.cols()*m1.channels()];
  m1.get(0, 0, data);
  printArray(data);

  Mat m2 = new Mat(new Size(3, 2), CvType.CV_8UC2, Scalar.all(0));
  m2.put(0, 0, 1, 2, 3, 4, 5, 6, 7, 8);
  println(m2.dump());
}