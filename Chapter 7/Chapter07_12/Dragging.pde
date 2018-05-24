import org.opencv.core.Rect;

// Define 3 states of mouse drag action.
public enum State {
    IDLE,
    DRAGGING, 
    SELECTED
}
// A class to handle the mouse drag action
public class Dragging {
  PVector p1, p2;
  Rect roi;
  State state;

  public Dragging() {
    p1 = new PVector(Float.MAX_VALUE, Float.MAX_VALUE);
    p2 = new PVector(Float.MIN_VALUE, Float.MIN_VALUE);
    roi = new Rect(0, 0, 0, 0);
    state = State.IDLE;
  }

  void init(PVector m) {
    empty(m);
    state = State.DRAGGING;
  }

  void update(PVector m) {
    p2.set(m.x, m.y);
    roi.x = (int)min(p1.x, p2.x);
    roi.y = (int)min(p1.y, p2.y);
    roi.width = (int)abs(p2.x-p1.x);
    roi.height = (int)abs(p2.y-p1.y);
  }

  void move(PVector m) {
    update(m);
  }

  void stop(PVector m) {
    update(m);
    state = State.SELECTED;
  }

  void empty(PVector m) {
    p1.set(m.x, m.y);
    p2.set(m.x, m.y);
    roi.x = (int)m.x;
    roi.y = (int)m.y;
    roi.width = 0;
    roi.height = 0;
  }

  void reset(PVector m) {
    empty(m);
    state = State.IDLE;
  }

  boolean isDragging() {
    return (state == State.DRAGGING);
  }

  boolean isSelected() {
    return (state == State.SELECTED);
  }  

  boolean isIdle() {
    return (state == State.IDLE);
  }

  Rect getRoi() {
    return roi;
  }
}