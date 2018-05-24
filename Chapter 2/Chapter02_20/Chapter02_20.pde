import org.opencv.core.*;
import org.opencv.videoio.*;
import org.opencv.imgproc.*;
import java.nio.ByteBuffer;
import java.util.ArrayList;

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
  Mat src = new Mat();
  cap.read(tmp);
  Imgproc.cvtColor(tmp, src, Imgproc.COLOR_BGR2RGBA);
  fm = src.clone();
  ArrayList<Mat> srcList = new ArrayList<Mat>();
  ArrayList<Mat> dstList = new ArrayList<Mat>();
  Core.split(src, srcList);
  Core.split(fm, dstList);
  MatOfInt info = new MatOfInt(0, 1, 1, 2, 2, 3, 3, 0);
  Core.mixChannels(srcList, dstList, info);
  println("Dimension " + info.size());
  Core.merge(dstList, fm);
  PImage img = matToImg(fm);
  image(img, 0, 0);
  text(nf(round(frameRate), 2), 10, 20);
  src.release();
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