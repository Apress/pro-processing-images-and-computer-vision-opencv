package cvimage;

import processing.core.*;
import org.opencv.core.*;
import org.opencv.imgproc.*;
import java.nio.ByteBuffer;
import java.util.ArrayList;

public class CVImage extends PImage {
  final private MatOfInt BGRA2ARGB = new MatOfInt(0, 3, 1, 2, 2, 1, 3, 0);
  final private MatOfInt ARGB2BGRA = new MatOfInt(0, 3, 1, 2, 2, 1, 3, 0);
  // cvImg - OpenCV Mat in BGRA format
  // pixCnt - number of bytes in the image
  private Mat cvImg;
  private int pixCnt;

  public CVImage(int w, int h) {
    super(w, h, ARGB);
    System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    pixCnt = w*h*4;
    cvImg = new Mat(new Size(w, h), CvType.CV_8UC4, Scalar.all(0));
  }

  public void copyTo() {
    // Copy from the PImage pixels array to the Mat cvImg
    Mat tmp = new Mat(new Size(this.width, this.height), CvType.CV_8UC4, Scalar.all(0));
    ByteBuffer b = ByteBuffer.allocate(pixCnt);
    b.asIntBuffer().put(this.pixels);
    b.rewind();
    tmp.put(0, 0, b.array());
    cvImg = ARGBToBGRA(tmp);
    tmp.release();
  }

  public void copyTo(PImage i) {
    // Copy from an external PImage to here
    if (i.width != this.width || i.height != this.height) {
      System.out.println("Size not identical");
      return;
    }
    PApplet.arrayCopy(i.pixels, this.pixels);
    this.updatePixels();
    copyTo();
  }

  public void copyTo(Mat m) {
    // Copy from an external Mat to both the Mat cvImg and PImage pixels array
    if (m.rows() != this.height || m.cols() != this.width) {
      System.out.println("Size not identical");
      return;
    }
    Mat out = new Mat(cvImg.size(), cvImg.type(), Scalar.all(0));
    switch (m.channels()) {
    case 1:
      // Greyscale image
      Imgproc.cvtColor(m, cvImg, Imgproc.COLOR_GRAY2BGRA);
      break;
    case 3:
      // 3 channels colour image BGR
      Imgproc.cvtColor(m, cvImg, Imgproc.COLOR_BGR2BGRA);
      break;
    case 4:
      // 4 channels colour image BGRA
      m.copyTo(cvImg);
      break;
    default:
      System.out.println("Invalid number of channels " + m.channels());
      return;
    }
    out = BGRAToARGB(cvImg);
    ByteBuffer b = ByteBuffer.allocate(pixCnt);
    out.get(0, 0, b.array());
    b.rewind();
    b.asIntBuffer().get(this.pixels);
    this.updatePixels();
    out.release();
  }

  private Mat BGRAToARGB(Mat m) {
    Mat tmp = new Mat(m.size(), CvType.CV_8UC4, Scalar.all(0));
    ArrayList<Mat> in = new ArrayList<Mat>();
    ArrayList<Mat> out = new ArrayList<Mat>();
    Core.split(m, in);
    Core.split(tmp, out);
    Core.mixChannels(in, out, BGRA2ARGB);
    Core.merge(out, tmp);
    return tmp;
  }

  private Mat ARGBToBGRA(Mat m) {
    Mat tmp = new Mat(m.size(), CvType.CV_8UC4, Scalar.all(0));
    ArrayList<Mat> in = new ArrayList<Mat>();
    ArrayList<Mat> out = new ArrayList<Mat>();
    Core.split(m, in);
    Core.split(tmp, out);
    Core.mixChannels(in, out, ARGB2BGRA);
    Core.merge(out, tmp);
    return tmp;
  }

  public Mat getBGRA() {
    // Get a copy of the Mat cvImg
    Mat mat = cvImg.clone();
    return mat;
  }

  public Mat getBGR() {
    // Get a 3 channels Mat in BGR
    Mat mat = new Mat(cvImg.size(), CvType.CV_8UC3, Scalar.all(0));
    Imgproc.cvtColor(cvImg, mat, Imgproc.COLOR_BGRA2BGR);
    return mat;
  }

  public Mat getGrey() {
    // Get a greyscale copy of the image
    Mat out = new Mat(cvImg.size(), CvType.CV_8UC1, Scalar.all(0));
    Imgproc.cvtColor(cvImg, out, Imgproc.COLOR_BGRA2GRAY);
    return out;
  }
}