import processing.video.*;
import org.opencv.core.*;
import java.nio.ByteBuffer;

Capture cap;
String colStr;
Mat fm;

void setup() {
  size(640, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, width, height);
  cap.start();
  frameRate(30);
  colStr = "";
  fm = new Mat();
}

void draw() {
  if (!cap.available()) 
    return;  
  background(0);
  cap.read();
  fm = imgToMat(cap);
  image(cap, 0, 0);
  text(nf(round(frameRate), 2), 10, 20); 
  text(colStr, 550, 20);
}

Mat imgToMat(PImage m) {
  Mat f = new Mat(new Size(m.width, m.height), CvType.CV_8UC4, 
    Scalar.all(0));
  ByteBuffer b = ByteBuffer.allocate(f.rows()*f.cols()*f.channels());
  b.asIntBuffer().put(m.pixels);
  b.rewind();
  f.put(0, 0, b.array());
  return f;
}

void mouseClicked() {
  int x = constrain(mouseX, 0, width-1);
  int y = constrain(mouseY, 0, height-1);
  double [] px = fm.get(y, x);
  colStr = nf(round((float)px[1]), 3) + ", " + 
    nf(round((float)px[2]), 3) + ", " + 
    nf(round((float)px[3]), 3);
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