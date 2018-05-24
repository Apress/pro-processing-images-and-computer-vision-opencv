PImage img1, img2;

void setup() {
  size(1500, 750);
  background(0);
  img1 = loadImage("landscape.png");
  img1.loadPixels();
  img2 = createImage(img1.width, img1.height, ARGB);
  img2.loadPixels();
  noLoop();
}

void draw() {
  for (int i=0; i<img1.pixels.length; i++) {
    color col = img1.pixels[i];
    img2.pixels[i] = color((red(col) + green(col) + blue(col))/3);
  }
  img2.updatePixels();
  image(img1, 0, 0);
  image(img2, img1.width, 0);
  saveFrame("data/greyscale.png");
}