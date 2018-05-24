import processing.video.*;

Capture cap;
PShape canvas;
int capW, capH;
float step;
PVector [][] points;
float angle;

void setup() {
  size(800, 600, P3D);
  hint(DISABLE_DEPTH_TEST);
  capW = 640;
  capH = 480;
  step = 20;
  cap = new Capture(this, capW, capH);
  cap.start();
  initGrid();
  initShape();
  shapeMode(CENTER);
  angle = 0;
}

void initGrid() {
  // initialize the matrix of points for texture mapping
  points = new PVector[floor(cap.height/step)+1][floor(cap.width/step)+1];
  for (int y=0; y<points.length; y++) {
    for (int x=0; x<points[y].length; x++) {
      float xVal = constrain(x*step, 0, cap.width-1);
      float yVal = constrain(y*step, 0, cap.height-1);
      // random z value
      points[y][x] = new PVector(xVal, yVal, noise(x*0.2, y*0.2)*60-30);
    }
  }
}

void initShape() {
  // initialize the GROUP PShape grid
  canvas = createShape(GROUP);
  for (int y=0; y<points.length-1; y++) {
    // initialize each row of the grid
    PShape tmp = createShape();
    tmp.beginShape(QUAD_STRIP);
    tmp.noStroke();
    tmp.texture(cap);
    for (int x=0; x<points[y].length; x++) {
      PVector p1 = points[y][x];
      PVector p2 = points[y+1][x];
      tmp.vertex(p1.x, p1.y, p1.z, p1.x, p1.y);
      tmp.vertex(p2.x, p2.y, p2.z, p2.x, p2.y);
    }
    tmp.endShape();
    canvas.addChild(tmp);
  }
}

void draw() {
  if (!cap.available()) 
    return;
  cap.read();
  lights();
  background(100);
  translate(width/2, height/2, -100);
  rotateX(radians(angle*1.3));
  rotateY(radians(angle));
  shape(canvas, 0, 0);
  angle += 0.5;
  angle %= 360;
}

void mousePressed() {
  saveFrame("data/shape.png");
}