// Dense optical flow
import processing.video.*;
import org.opencv.video.*;
import org.opencv.video.Video;

// Capture size
final int CAPW = 640;
final int CAPH = 480;

Capture cap;
CVImage img;
float scaling;
int w, h;
Mat last;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, CAPW, CAPH);
  cap.start();
  scaling = 10;
  w = floor(CAPW/scaling);
  h = floor(CAPH/scaling);
  img = new CVImage(w, h);
  last = new Mat(h, w, CvType.CV_8UC1);
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  img.copyTo();
  Mat grey = img.getGrey();
  Mat flow = new Mat(last.size(), CvType.CV_32FC2);
  Video.calcOpticalFlowFarneback(last, grey, flow, 
    0.5, 3, 10, 2, 7, 1.5, Video.OPTFLOW_FARNEBACK_GAUSSIAN);
  grey.copyTo(last);
  image(cap, 0, 0);
  drawFlow(flow);
  grey.release();
  flow.release();
  text(nf(round(frameRate), 2), 10, 20);
}

void drawFlow(Mat f) {
  // Draw the flow data.
  pushStyle();
  noFill();
  for (int y=0; y<f.rows(); y++) {
    int py = (int)constrain(y*scaling, 0, cap.height-1);
    for (int x=0; x<f.cols(); x++) {
      double [] pt = f.get(y, x);
      float dx = (float)pt[0];
      float dy = (float)pt[1];
      // Skip areas with no flow.
      if (dx == 0 && dy == 0) 
        continue;
      int px = (int)constrain(x*scaling, 0, cap.width-1);
      color col = cap.pixels[py*cap.width+px];
      stroke(col);
      dx *= scaling;
      dy *= scaling;
      line(px+cap.width, py, px+cap.width+dx, py+dy);
    }
  }
  popStyle();
}

void mousePressed() {
  saveFrame("data/flow####.jpg");
}