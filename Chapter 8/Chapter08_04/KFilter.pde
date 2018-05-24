// Kalman filter
import org.opencv.video.KalmanFilter;

public class KFilter {
  KalmanFilter kf;
  MatOfFloat measurement;
  int numS;
  int numM;

  public KFilter(int s, int m) {
    // Initialize the Kalman filter with 
    // number of states and measurements.
    // Our measurements are the x, y location of
    // the face rectangle and its width and height.
    numS = s;
    numM = m;
    kf = new KalmanFilter(numS, numM, 0, CvType.CV_32F);
    float [] tmp = new float[numM];
    for (int i=0; i<tmp.length; i++) {
      tmp[i] = 0;
    }
    measurement = new MatOfFloat(tmp);
  }

  void initFilter(int fps) {
    // Initialize the state transition matrix.
    double dt1 = 1.0/fps;
    Mat tmp = Mat.eye(numS, numS, CvType.CV_32F);
    tmp.put(0, 4, dt1);
    tmp.put(1, 5, dt1);
    tmp.put(2, 6, dt1);
    tmp.put(3, 7, dt1);
    kf.set_transitionMatrix(tmp);

    // Initialize the measurement matrix.
    tmp = kf.get_measurementMatrix();
    for (int i=0; i<numM; i++) {
      tmp.put(i, i, 1);
    }
    kf.set_measurementMatrix(tmp);

    tmp = kf.get_processNoiseCov();
    Core.setIdentity(tmp, Scalar.all(1e-5));
    kf.set_processNoiseCov(tmp);
    tmp = kf.get_measurementNoiseCov();
    Core.setIdentity(tmp, Scalar.all(1e-2));
    kf.set_measurementNoiseCov(tmp);
    tmp = kf.get_errorCovPost();
    Core.setIdentity(tmp, Scalar.all(1));
    kf.set_errorCovPost(tmp);
    tmp.release();
  }

  MatOfFloat updateFilter(float x, float y, float w, float h) {
    // Update the Kalman filter with latest measurements on
    // x, y locations and width, height.
    Mat prediction = kf.predict();
    measurement.fromArray(new float[]{x, y, w, h});
    MatOfFloat estimated = new MatOfFloat(kf.correct(measurement));
    prediction.release();
    // Return the estimated version of the 4 measurements.
    return estimated;
  }
}