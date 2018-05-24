CVImage img1, img2, img3;

void setup() {
  size(1200, 900);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  background(0);
  PImage tmp = loadImage("hongkong.png");
  img1 = new CVImage(tmp.width, tmp.height);
  img2 = new CVImage(tmp.width, tmp.height);
  img3 = new CVImage(tmp.width, tmp.height);
  img1.copyTo(tmp);
  tmp = loadImage("sydney.png");
  img2.copyTo(tmp);
  noLoop();
}

void draw() {
  Mat m1 = img1.getBGR();
  Mat m2 = img2.getBGR();
  Mat m3 = new Mat(m1.size(), m1.type());
  Core.add(m1, m2, m3);
  img3.copyTo(m3);
  image(img3, 0, 0);
  m1.release();
  m2.release();
  m3.release();
  saveFrame("data/blend.png");
}