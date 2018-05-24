import org.opencv.core.*;
import java.nio.ByteBuffer;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  noLoop();
}

void draw() {
  background(0);
  Mat fm = new Mat(new Size(width, height), CvType.CV_8UC4, new Scalar(255, 255, 200, 0));
  PImage img = matToImg(fm);
  image(img, 0, 0);
}

PImage matToImg(Mat m) {
  PImage im = createImage(m.cols(), m.rows(), ARGB);
  ByteBuffer b = ByteBuffer.allocate(m.rows()*m.cols()*m.channels());
  m.get(0, 0, b.array());
  b.rewind();
  b.asIntBuffer().get(im.pixels);
  im.updatePixels();
  return im;
}