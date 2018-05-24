PImage img;

void setup() {
  size(640, 480);
  background(100, 100, 100);
  img = createImage(width, height, ARGB);
  color yellow = color(255, 255, 0);
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {
      img.set(x, y, yellow);
    }
  }
}

void draw() {
  image(img, 0, 0);
}