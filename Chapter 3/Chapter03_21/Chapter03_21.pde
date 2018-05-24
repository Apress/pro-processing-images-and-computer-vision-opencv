PImage img1, img2;

void setup() {
  size(1200, 900);
  background(0);
  img1 = loadImage("hongkong.png");
  img2 = loadImage("sydney.png");
  noLoop();
}

void draw() {
  img1.blend(img2, 0, 0, img2.width, img2.height, 
    0, 0, img1.width, img1.height, ADD);
  image(img1, 0, 0);
}