import processing.video.*;

Movie mov;

void setup() {
  size(640, 360);
  background(0);
  mov = new Movie(this, "transit.mov");
  mov.loop();
}

void draw() {
  image(mov, 0, 0);
}

void movieEvent(Movie m) {
  m.read();
}