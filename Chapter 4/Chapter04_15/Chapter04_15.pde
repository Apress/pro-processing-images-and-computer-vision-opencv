PImage img1, img2;
float angle;

void setup() {
  size(1200, 600);
  img1 = loadImage("hongkong.png");
  img2 = createImage(img1.width, img1.height, ARGB);
  angle = 0;
}

void draw() {
  // Variables rx, ry are for the radii of the sine/cosine functions
  // Variables ax, ay are for the angles of the sine/cosine functions
  background(0);
  for (int y=0; y<img2.height; y++) {
    float ay = y*angle/img2.height;
    float ry = y*angle/360.0;
    for (int x=0; x<img2.width; x++) {
      float ax = x*angle/img2.width;
      float rx = x*angle/360.0;
      int x1 = x + (int)(rx*cos(radians(ay)));
      int y1 = y + (int)(ry*sin(radians(ax)));
      x1 = constrain(x1, 0, img1.width-1);
      y1 = constrain(y1, 0, img1.height-1);
      img2.pixels[y*img2.width+x] = img1.pixels[y1*img1.width+x1];
    }
  }
  angle += 1;
  angle %= 360;
  img2.updatePixels();
  image(img1, 0, 0);
  image(img2, img1.width, 0);
}

void mousePressed() {
  saveFrame("data/fun####.png");
}