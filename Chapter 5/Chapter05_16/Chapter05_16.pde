import processing.video.*;

Capture cap;
CVImage img;
LineSegmentDetector line;

void setup() {
  size(1280, 480);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  line = Imgproc.createLineSegmentDetector();
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  img.copyTo(cap);
  Mat tmp1 = img.getGrey();
  Mat lines = new Mat();
  line.detect(tmp1, lines);
  pushStyle();
  for (int i=0; i<lines.rows(); i++) {
    double [] pts = lines.get(i, 0);
    float x1 = (float)pts[0];
    float y1 = (float)pts[1];
    float x2 = (float)pts[2];
    float y2 = (float)pts[3];
    int mx = (int)constrain((x1+x2)/2, 0, cap.width-1);
    int my = (int)constrain((y1+y2)/2, 0, cap.height-1);
    color col = cap.pixels[my*cap.width+mx];
    stroke(col);
    strokeWeight(random(1, 3));
    line(x1+cap.width, y1, x2+cap.width, y2);
  }
  popStyle();
  image(cap, 0, 0);
  text(nf(round(frameRate), 2), 10, 20);
  tmp1.release();
  lines.release();
}

void mousePressed() {
  saveFrame("data/Lines.png");
}