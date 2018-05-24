import java.awt.Robot;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;

Robot robot;

void setup() {
  size(640, 480);
  try {
    robot = new Robot();
  } 
  catch (Exception e) {
    println(e.getMessage());
  }
}

void draw() {
  background(0);
  Rectangle rec = new Rectangle(mouseX, mouseY, 
    width, height);
  BufferedImage img1 = robot.createScreenCapture(rec);
  PImage img2 = new PImage(img1);
  image(img2, 0, 0);
}