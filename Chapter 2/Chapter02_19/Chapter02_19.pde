import org.opencv.core.*;
import org.opencv.videoio.*;
import org.opencv.imgproc.*;
import java.nio.ByteBuffer;

VideoCapture cap;
Mat fm;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new VideoCapture();
  cap.set(Videoio.CAP_PROP_FRAME_WIDTH, width);
  cap.set(Videoio.CAP_PROP_FRAME_HEIGHT, height);
  cap.open(Videoio.CAP_ANY);
  fm = new Mat();
  frameRate(30);
}

void draw() {
  background(0);
  Mat tmp = new Mat();
  cap.read(tmp);
  Imgproc.cvtColor(tmp, fm, Imgproc.COLOR_BGR2RGBA);
  PImage img = matToImg(fm);
  image(img, 0, 0);
  text(nf(round(frameRate), 2), 10, 20); 
  tmp.release();
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