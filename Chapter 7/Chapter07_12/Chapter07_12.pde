// Features matching with selection
import processing.video.*;
import java.util.Arrays;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.features2d.FeatureDetector;
import org.opencv.features2d.DescriptorExtractor;
import org.opencv.features2d.DescriptorMatcher;
import org.opencv.calib3d.Calib3d;

Capture cap;
CVImage img;
// Feature detector, extractor and matcher
FeatureDetector fd;
DescriptorExtractor de;
DescriptorMatcher match;
// Key points and descriptors for train and query
MatOfKeyPoint trainKp, queryKp;
Mat trainDc, queryDc;
// Buffer for the trained image
PImage trainImg;
// A class to work with mouse drag & selection
Dragging drag;
Mat hg;
MatOfPoint2f trainRect, queryRect;
PImage photo;

void setup() {
  size(1280, 480, P3D);
  background(0);
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  cap = new Capture(this, width/2, height);
  cap.start();
  img = new CVImage(cap.width, cap.height);
  trainImg = createImage(cap.width, cap.height, ARGB);
  fd = FeatureDetector.create(FeatureDetector.ORB);
  de = DescriptorExtractor.create(DescriptorExtractor.ORB);
  match = DescriptorMatcher.create(DescriptorMatcher.BRUTEFORCE_HAMMING);
  trainKp = new MatOfKeyPoint();
  queryKp = new MatOfKeyPoint();
  trainDc = new Mat();
  queryDc = new Mat();
  hg = Mat.eye(3, 3, CvType.CV_32FC1);
  drag = new Dragging();
  smooth();
  trainRect = new MatOfPoint2f();
  queryRect = new MatOfPoint2f();
  photo = loadImage("portrait.png");
  textureMode(NORMAL);
}

void draw() {
  if (!cap.available()) 
    return;
  background(0);
  cap.read();
  cap.updatePixels();
  img.copy(cap, 0, 0, cap.width, cap.height, 
    0, 0, img.width, img.height);
  img.copyTo();
  Mat grey = img.getGrey();
  image(trainImg, 0, 0);
  image(cap, trainImg.width, 0);

  if (drag.isDragging()) {
    drawRect(cap.width);
  } else if (drag.isSelected()) {
    drawRect(0);
    matchPoints(grey);
    //    drawTrain();
    //    drawQuery();
  }
  pushStyle();
  fill(80);
  text(nf(round(frameRate), 2), 10, 20);
  popStyle();
  grey.release();
}

void matchPoints(Mat im) {
  // Match the trained and query key points.
  fd.detect(im, queryKp);
  de.compute(im, queryKp, queryDc);
  // Skip if the trained or query descriptors are empty.
  if (!queryDc.empty() && 
    !trainDc.empty()) {
    MatOfDMatch pairs = new MatOfDMatch();
    match.match(queryDc, trainDc, pairs);   
    DMatch [] dm = pairs.toArray();
    // Convert trained and query MatOfKeyPoint to array.
    KeyPoint [] tKp = trainKp.toArray();
    KeyPoint [] qKp = queryKp.toArray();
    float minDist = Float.MAX_VALUE;
    float maxDist = Float.MIN_VALUE;
    // Obtain the min and max distances of matching.
    for (DMatch d : dm) {
      if (d.distance < minDist) {
        minDist = d.distance;
      }
      if (d.distance > maxDist) {
        maxDist = d.distance;
      }
    }
    float thresVal = 2*minDist;
    ArrayList<Point> trainList = new ArrayList<Point>();
    ArrayList<Point> queryList = new ArrayList<Point>();
    pushStyle();
    noFill();
    stroke(255);
    for (DMatch d : dm) {
      if (d.queryIdx >= qKp.length ||
        d.trainIdx >= tKp.length) 
        continue;
      // Skip match data with distance larger than 
      // 2 times of min distance.
      if (d.distance > thresVal) 
        continue;
      KeyPoint t = tKp[d.trainIdx];
      KeyPoint q = qKp[d.queryIdx];
      trainList.add(t.pt);
      queryList.add(q.pt);
      // Draw a line for each pair of matching key points.
      //line((float)t.pt.x, (float)t.pt.y, 
      //  (float)q.pt.x+cap.width, (float)q.pt.y);
    }
    MatOfPoint2f trainM = new MatOfPoint2f();
    MatOfPoint2f queryM = new MatOfPoint2f();
    trainM.fromList(trainList);
    queryM.fromList(queryList);
    // Find the homography matrix between the trained
    // key points and query key points.
    // Proceed only with more than 5 key points.
    if (trainList.size() > 5 && 
      queryList.size() > 5) {
      hg = Calib3d.findHomography(trainM, queryM, Calib3d.RANSAC, 3.0);
      if (!hg.empty()) {
        // Perform perspective transform to the 
        // selection rectangle with the homography matrix.
        Core.perspectiveTransform(trainRect, queryRect, hg);
      }
      pairs.release();
      trainM.release();
      queryM.release();
      hg.release();
    }
    if (!queryRect.empty()) {
      // Draw the transformed selection matrix.
      Point [] out = queryRect.toArray();
      noStroke();
      fill(255);
      beginShape();
      texture(photo);
      vertex((float)out[0].x+cap.width, (float)out[0].y, 0, 0, 0);
      vertex((float)out[1].x+cap.width, (float)out[1].y, 0, 1, 0);
      vertex((float)out[2].x+cap.width, (float)out[2].y, 0, 1, 1);
      vertex((float)out[3].x+cap.width, (float)out[3].y, 0, 0, 1);
      endShape(CLOSE);
    }
  }
  popStyle();
}

void drawRect(float ox) {
  // Draw the selection rectangle.
  pushStyle();
  noFill();
  stroke(255, 255, 0);
  rect(drag.getRoi().x+ox, drag.getRoi().y, 
    drag.getRoi().width, drag.getRoi().height);
  popStyle();
}

void drawTrain() {
  // Draw the trained key points.
  pushStyle();
  noFill();
  stroke(255, 200, 0);
  KeyPoint [] kps = trainKp.toArray();
  for (KeyPoint kp : kps) {
    float x = (float)kp.pt.x;
    float y = (float)kp.pt.y;
    ellipse(x, y, 10, 10);
  }
  popStyle();
}

void drawQuery() {
  // Draw live image key points.
  pushStyle();
  noFill();
  stroke(255, 200, 0);
  KeyPoint [] kps = queryKp.toArray();
  for (KeyPoint kp : kps) {
    float x = (float)kp.pt.x;
    float y = (float)kp.pt.y;
    ellipse(x+trainImg.width, y, 10, 10);
  }
  popStyle();
}

void mouseClicked() {
  // Reset the drag rectangle.
  drag.reset(new PVector(0, 0));
}

void mousePressed() {
  // Click only on the right hand side of the window
  // to start the drag action.
  if (mouseX < cap.width || mouseX >= cap.width*2) 
    return;
  if (mouseY < 0 || mouseY >= cap.height)
    return;
  drag.init(new PVector(mouseX-cap.width, mouseY));
}

void mouseDragged() {
  // Drag the selection rectangle.
  int x = constrain(mouseX, cap.width, cap.width*2-1);
  int y = constrain(mouseY, 0, cap.height-1);
  drag.move(new PVector(x-cap.width, y));
}

void mouseReleased() {
  // Finalize the selection rectangle.
  int x = constrain(mouseX, cap.width, cap.width*2-1);
  int y = constrain(mouseY, 0, cap.height-1);
  drag.stop(new PVector(x-cap.width, y));

  // Compute the trained key points and descriptor.
  arrayCopy(cap.pixels, trainImg.pixels);
  trainImg.updatePixels();
  CVImage tBGR = new CVImage(trainImg.width, trainImg.height);
  tBGR.copy(trainImg, 0, 0, trainImg.width, trainImg.height, 
    0, 0, tBGR.width, tBGR.height);
  tBGR.copyTo();
  Mat temp = tBGR.getGrey();
  Mat tTrain = new Mat();
  // Detect and compute key points and descriptors.
  fd.detect(temp, trainKp);
  de.compute(temp, trainKp, tTrain);
  // Define the selection rectangle.
  Rect r = drag.getRoi();
  // Convert MatOfKeyPoint to array.
  KeyPoint [] iKpt = trainKp.toArray();
  ArrayList<KeyPoint> oKpt = new ArrayList<KeyPoint>();
  trainDc.release();
  // Select only the key points inside selection rectangle.
  for (int i=0; i<iKpt.length; i++) {
    if (r.contains(iKpt[i].pt)) {
      // Add key point to the output list.
      oKpt.add(iKpt[i]);
      trainDc.push_back(tTrain.row(i));
    }
  }
  trainKp.fromList(oKpt);
  // Compute the selection rectangle as MatOfPoint2f.
  ArrayList<Point> quad = new ArrayList<Point>();
  quad.add(new Point(r.x, r.y));
  quad.add(new Point(r.x+r.width, r.y));
  quad.add(new Point(r.x+r.width, r.y+r.height));
  quad.add(new Point(r.x, r.y+r.height));
  trainRect.fromList(quad);
  queryRect.release();
  tTrain.release();
  temp.release();
}

void keyPressed() {
  saveFrame("data/match####.jpg");
}