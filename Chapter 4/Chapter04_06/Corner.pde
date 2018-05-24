public class Corner {
  float radius;
  PVector pos;
  boolean picked;

  public Corner(float x, float y) {
    pos = new PVector(x, y);
    radius = 10.0;
    picked = false;
  }

  PVector getPos() {
    return pos;
  }
  
  void drag(float x, float y) {
    if (picked) {
      PVector p = new PVector(x, y);
      pos.set(p.x, p.y);
    }
  }

  void pick(float x, float y) {
    PVector p = new PVector(x, y);
    float d = p.dist(pos);
    if (d < radius) {
      picked = true;
      pos.set(p.x, p.y);
    }
  }

  void unpick() {
    picked = false;
  }

  void draw() {
    pushStyle();
    fill(255, 255, 0, 160);
    noStroke();
    ellipse(pos.x, pos.y, radius*2, radius*2);
    popStyle();
  }
}