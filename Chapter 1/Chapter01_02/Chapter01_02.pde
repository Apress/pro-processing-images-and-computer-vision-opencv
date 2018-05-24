import org.opencv.core.Core;

void setup() {
  size(640, 480);
  println(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
}

void draw() {
  background(100, 100, 100);
}