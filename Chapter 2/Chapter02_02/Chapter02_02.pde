PImage img;
String fName;

void setup() {
  size(640, 480);
  background(255, 200, 200);
  fName = "http://www.magicandlove.com/blog/wp-content/uploads/2011/10/BryanChung-225x300.png";
  img = requestImage(fName);
}

void draw() {
  if (img.width > 0 && img.height > 0) {
    image(img, 360, 100);
  }
}