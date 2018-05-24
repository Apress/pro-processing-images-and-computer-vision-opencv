PImage img;

void setup() {
  size(1200, 600);
  img = loadImage("hongkong.png");
  noLoop();
}

void draw() {
  background(0);
  PImage small = createImage(round(img.width*0.5), 
    round((int)img.height*0.5), ARGB);
  small.copy(img, 0, 0, img.width, img.height, 
    0, 0, small.width, small.height);
  small.updatePixels();
  image(img, 0, 0);
  tint(255, 100, 100);
  image(small, img.width, 0);
  tint(100, 100, 255);
  image(small, img.width, small.height);
  //  saveFrame("data/resize.png");
}