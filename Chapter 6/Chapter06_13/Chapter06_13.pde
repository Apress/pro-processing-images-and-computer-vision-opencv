// Interaction design with optical flow
import processing.video.*;
import org.opencv.video.*;
import org.opencv.video.Video;
import java.awt.Rectangle;

// Capture size
final int CAPW = 640;
final int CAPH = 480;

Capture cap;
CVImage img;
float scaling;
int w, h;
Mat last;
Region [] regions;
// Flag to indicate if it is the first frame.
boolean first;
// Offset to the right hand side display.
PVector offset;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, CAPW, CAPH);
  cap.start();
  scaling = 20;
  w = floor(CAPW/scaling);
  h = floor(CAPH/scaling);
  img = new CVImage(w, h);
  last = new Mat(h, w, CvType.CV_8UC1);
  Rectangle screen = new Rectangle(0, 0, cap.width, cap.height);
  // Define 2 hotspots.
  regions = new Region[2];
  regions[0] = new Region(this, new Rectangle(100, 100, 100, 100), 
    screen, scaling);
  regions[1] = new Region(this, new Rectangle(500, 200, 100, 100), 
    screen, scaling);
  first = true;
  offset = new PVector(cap.width, 0);
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
  if (first) {
    grey.copyTo(last);
    first = false;
    return;
  }
  Mat flow = new Mat(last.size(), CvType.CV_32FC2);
  Video.calcOpticalFlowFarneback(last, grey, flow, 
    0.5, 3, 10, 2, 7, 1.5, Video.OPTFLOW_FARNEBACK_GAUSSIAN);
  grey.copyTo(last);
  image(cap, 0, 0);
  drawFlow(flow);
  // Update the hotspots with the flow matrix.
  // Draw the hotspot rectangle.
  // Draw also the flow on the right hand side display.
  for (Region rg : regions) {
    rg.update(flow);
    rg.drawBox();
    rg.drawFlow(flow, offset);
  }
  grey.release();
  flow.release();
  text(nf(round(frameRate), 2), 10, 20);
}

void drawFlow(Mat f) {
  // Draw the flow data.
  pushStyle();
  noFill();
  stroke(255);
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
      dx *= scaling;
      dy *= scaling;
      line(px, py, px+dx, py+dy);
    }
  }
  popStyle();
}

void regionTriggered(Region r) {
  // Callback function from the Region class.
  // It displays the flow magnitude number on 
  // top of the hotspot rectangle.
  int mag = round(r.getFlowMag());
  r.writeMsg(offset, nf(mag, 3));
}

void mousePressed() {
  saveFrame("data/flow####.jpg");
}