PImage img1, img2, img3;

void setup() {
  size(1200, 900);
  background(0);
  img1 = loadImage("hongkong.png");
  img2 = loadImage("sydney.png");
  img3 = createImage(img1.width, img1.height, ARGB);
  noLoop();
}

void draw() {
  for (int i=0; i<img1.pixels.length; i++) {
    color c1 = img1.pixels[i];
    color c2 = img2.pixels[i];
    float r = constrain(red(c1) + red(c2), 0, 255);
    float g = constrain(green(c1) + green(c2), 0, 255);
    float b = constrain(blue(c1) + blue(c2), 0, 255);
    img3.pixels[i] = color(r, g, b);
  }
  img3.updatePixels();
  image(img3, 0, 0);
  saveFrame("data/blend.png");
}