import org.opencv.core.*;
import org.opencv.imgproc.*;

PImage img;
CVImage cvout;
PVector offset;
MatOfPoint2f srcMat, dstMat;
Mat in;
Corner [] corners;

void setup() {
  size(720, 720);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  img = loadImage("hongkong.png");
  CVImage cvin = new CVImage(img.width, img.height);
  cvin.copyTo(img);
  in = cvin.getBGR();
  cvout = new CVImage(img.width, img.height);
  offset = new PVector((width-img.width)/2, (height-img.height)/2);
  srcMat = new MatOfPoint2f(new Point(0, 0), 
    new Point(img.width-1, 0), 
    new Point(img.width-1, img.height-1));
  dstMat = new MatOfPoint2f();
  corners = new Corner[srcMat.rows()];
  corners[0] = new Corner(0+offset.x, 0+offset.y);
  corners[1] = new Corner(img.width-1+offset.x, 0+offset.y);
  corners[2] = new Corner(img.width-1+offset.x, img.height-1+offset.y);
}

void draw() {
  background(0);
  drawFrame();
  Point [] points = new Point[corners.length];
  for (int i=0; i<corners.length; i++) {
    PVector p = corners[i].getPos();
    points[i] = new Point(p.x-offset.x, p.y-offset.y);
  }
  dstMat.fromArray(points);
  Mat affine = Imgproc.getAffineTransform(srcMat, dstMat);
  Mat out = new Mat(in.size(), in.type());
  Imgproc.warpAffine(in, out, affine, out.size());
  cvout.copyTo(out);
  image(cvout, offset.x, offset.y);
  for (Corner c : corners) {
    c.draw();
  }
  out.release();
  affine.release();
}

void drawFrame() {
  pushStyle();
  noFill();
  stroke(100);
  line(offset.x-1, offset.y-1, 
    img.width+offset.x, offset.y-1);
  line(img.width+offset.x, offset.y-1, 
    img.width+offset.x, img.height+offset.y);
  line(offset.x-1, img.height+offset.y, 
    img.width+offset.x, img.height+offset.y);
  line(offset.x-1, offset.y-1, 
    offset.x-1, img.height+offset.y);
  popStyle();
}

void mousePressed() {
  for (Corner c : corners) {
    c.pick(mouseX, mouseY);
  }
}

void mouseDragged() {
  for (Corner c : corners) {
    if (mouseX<offset.x || 
      mouseX>offset.x+img.width ||
      mouseY<offset.y ||
      mouseY>offset.y+img.height) 
      continue;
    c.drag(mouseX, mouseY);
  }
}

void mouseReleased() {
  for (Corner c : corners) {
    c.unpick();
  }
  saveFrame("data/affine.png");
}