import processing.video.*;

Movie mov;

void setup() {
  size(640, 360);
  background(0);
  mov = new Movie(this, "transit.mov");
  mov.loop();
  frameRate(30);
}

void draw() {
  if (mov.available()) {
    mov.read();
  }
  image(mov, 0, 0);
}