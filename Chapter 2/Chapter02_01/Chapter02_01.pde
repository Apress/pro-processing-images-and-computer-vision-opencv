PImage img;

void setup() {
  size(640, 480);
  img = loadImage("HongKong.png");
  noLoop();
}

void draw() {
  image(img, 0, 0);
}