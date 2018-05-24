import processing.video.*;

Capture cap;
PImage img;
PShape canvas;
int capW, capH;
float angle;
int vCnt;

void setup() {
  size(800, 600, P3D);
  hint(DISABLE_DEPTH_TEST);
  capW = 640;
  capH = 480;
  cap = new Capture(this, capW, capH);
  cap.start();
  img = loadImage("hongkong.png");
  canvas = createShape();
  canvas.beginShape();
  canvas.textureMode(NORMAL);
  canvas.texture(cap);
  canvas.noStroke();
  canvas.vertex(0, 0, 0, 0, 0);
  canvas.vertex(cap.width, 0, 0, 1, 0);
  canvas.vertex(cap.width, cap.height, 0, 1, 1);
  canvas.vertex(0, cap.height, 0, 0, 1);
  canvas.endShape(CLOSE);
  shapeMode(CENTER);
  angle = 0;
  vCnt = canvas.getVertexCount();
}

void draw() {
  if (!cap.available()) 
    return;
  cap.read();
  background(0);
  image(img, 0, 0);
  for (int i=0; i<vCnt; i++) {
    PVector pos = canvas.getVertex(i);
    if (i < 2) {
      pos.z = 100*cos(radians(angle*3));
    } else {
      pos.z = 100*sin(radians(angle*5));
    }
    canvas.setVertex(i, pos);
  }
  translate(width/2, height/2, -100);
  rotateY(radians(angle));
  shape(canvas, 0, 0);
  angle += 0.5;
  angle %= 360;
}

void mousePressed() {
  saveFrame("data/shape.png");
}