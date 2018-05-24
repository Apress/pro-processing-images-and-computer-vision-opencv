import processing.video.*;

Capture cap;
int capW, capH;
float step;
PVector [][] points;
float angle;
PShape canvas;

void setup() {
  size(800, 600, P3D);
  hint(DISABLE_DEPTH_TEST);
  capW = 640;
  capH = 480;
  step = 10;
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
      points[y][x] = new PVector(xVal, yVal, 0);
    }
  }
}

void initShape() {
  canvas = createShape(GROUP);
  for (int y=0; y<points.length-1; y++) {
    // initialize each row of the grid
    PShape tmp = createShape();
    tmp.beginShape(QUAD_STRIP);
    //tmp.noFill();
    tmp.noStroke();
    for (int x=0; x<points[y].length; x++) {
      PVector p1 = points[y][x];
      PVector p2 = points[y+1][x];
      tmp.vertex(p1.x, p1.y, p1.z);
      tmp.vertex(p2.x, p2.y, p2.z);
    }
    tmp.endShape();
    canvas.addChild(tmp);
  }
}

color getColor(int x, int y) {
  // obtain color information from cap
  int x1 = constrain(floor(x*step), 0, cap.width-1);
  int y1 = constrain(floor(y*step), 0, cap.height-1);
  return cap.get(x1, y1);
}

void updatePoints() {
  // update the depth of vertices using color 
  // brightness from cap
  float factor = 0.3;
  for (int y=0; y<points.length; y++) {
    for (int x=0; x<points[y].length; x++) {
      color c = getColor(x, y);
      points[y][x].z = brightness(c)*factor;
    }
  }
}

void updateShape() {
  // update the color and depth of vertices
  for (int i=0; i<canvas.getChildCount(); i++) {
    for (int j=0; j<canvas.getChild(i).getVertexCount(); j++) {
      PVector p = canvas.getChild(i).getVertex(j);
      int x = constrain(floor(p.x/step), 0, points[0].length-1);
      int y = constrain(floor(p.y/step), 0, points.length-1);
      p.z = points[y][x].z;
      color c = getColor(x, y);
      canvas.getChild(i).setFill(j, c);
      canvas.getChild(i).setVertex(j, p);
    }
  }
}

void draw() {
  if (!cap.available()) 
    return;
  cap.read();
  // cap.updatePixels();
  updatePoints();
  updateShape();
  background(0);
  translate(width/2, height/2, -100);
  rotateX(radians(angle));
  shape(canvas, 0, 0);
  angle += 0.5;
  angle %= 360;
}

void mousePressed() {
  saveFrame("data/shape.png");
}