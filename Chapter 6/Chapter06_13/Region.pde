import java.awt.Rectangle;
import java.lang.reflect.Method;

// The class to define the hotspot.
class Region {
  // Threshold value to trigger the callback function.
  final float FLOW_THRESH = 20;
  Rectangle rct;     // area of the hotspot
  Rectangle screen;  // area of the live capture
  float scaling;     // scaling factor for optical flow size
  PVector flowInfo;  // flow information within the hotspot
  PApplet parent;
  Method func;       // callback function
  boolean touched;

  public Region(PApplet p, Rectangle r, Rectangle s, float f) {
    parent = p;
    // Register the callback function named regionTriggered.
    try {
      func = p.getClass().getMethod("regionTriggered", 
        new Class[]{this.getClass()});
    } 
    catch (Exception e) {
      println(e.getMessage());
    }
    screen = s;
    rct = (Rectangle)screen.createIntersection(r);
    scaling = f;
    flowInfo = new PVector(0, 0);
    touched = false;
  }

  void update(Mat f) {
    Rect sr = new Rect(floor(rct.x/scaling), floor(rct.y/scaling), 
      floor(rct.width/scaling), floor(rct.height/scaling));
    // Obtain the submatrix - region of interest.
    Mat flow = f.submat(sr);
    flowInfo.set(0, 0);
    // Accumulate the optical flow vectors.
    for (int y=0; y<flow.rows(); y++) {
      for (int x=0; x<flow.cols(); x++) {
        double [] vec = flow.get(y, x);
        PVector item = new PVector((float)vec[0], (float)vec[1]);
        flowInfo.add(item);
      }
    }
    flow.release();
    // When the magnitude of total flow is larger than a
    // threshold, trigger the callback.
    if (flowInfo.mag()>FLOW_THRESH) {
      touched = true;
      try {
        func.invoke(parent, this);
      } 
      catch (Exception e) {
        println(e.getMessage());
      }
    } else {
      touched = false;
    }
  }

  void drawBox() {
    // Draw the hotspot rectangle.
    pushStyle();
    if (touched) {
      stroke(255, 200, 0);
      fill(0, 100, 255, 160);
    } else {
      stroke(160);
      noFill();
    }
    rect((float)(rct.x+screen.x), (float)(rct.y+screen.y), 
      (float)rct.width, (float)rct.height);
    popStyle();
  }

  void drawFlow(Mat f, PVector o) {
    // Visualize flow inside the region on 
    // the right hand side screen.
    Rect sr = new Rect(floor(rct.x/scaling), floor(rct.y/scaling), 
      floor(rct.width/scaling), floor(rct.height/scaling));
    Mat flow = f.submat(sr);
    pushStyle();
    noFill();
    stroke(255);
    for (int y=0; y<flow.rows(); y++) {
      float y1 = y*scaling+rct.y + o.y;
      for (int x=0; x<flow.cols(); x++) {
        double [] vec = flow.get(y, x);
        float x1 = x*scaling+rct.x + o.x;
        float dx = (float)(vec[0]*scaling);
        float dy = (float)(vec[1]*scaling);
        line(x1, y1, x1+dx, y1+dy);
      }
    }
    popStyle();
    flow.release();
  }

  float getFlowMag() {
    // Get the flow vector magnitude.
    return flowInfo.mag();
  }

  void writeMsg(PVector o, String m) {
    // Display message on screen.
    int px = round(o.x + rct.x);
    int py = round(o.y + rct.y);
    text(m, px, py-10);
  }
}