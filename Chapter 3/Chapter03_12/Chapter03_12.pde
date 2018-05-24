PImage img;
float xScale, yScale;

void setup() {
  size(750, 750);
  background(0);
  img = createImage(width, height, ARGB);
  img.loadPixels();
  xScale = 0.01;
  yScale = 0.01;
  noLoop();
}

void draw() {
  for (int y=0; y<img.height; y++) {
    int rows = y*img.width;
    for (int x=0; x<img.width; x++) {
      img.pixels[rows+x] = color(floor(noise(x*xScale, y*yScale)*256));
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}