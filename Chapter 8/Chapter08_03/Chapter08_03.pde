// Shutdown computer in Windows.
import java.lang.Process;
import java.lang.Runtime;
import java.io.*;

String comm;
String pw;

void setup() {
  size(640, 480);
  // Command string
  comm = "shutdown -s -t 0";
}

void draw() {
  background(0);
}

void mousePressed() {
  shutdown();
}

void shutdown() {
  try {
    // Execute the shutdown command.
    Process proc = Runtime.getRuntime().exec(comm);
    BufferedReader buf = new BufferedReader(
      new InputStreamReader(proc.getInputStream()));
    BufferedReader err = new BufferedReader(
      new InputStreamReader(proc.getErrorStream()));
    // Print out the messages.
    String line;
    println("Output message");
    while ((line = buf.readLine()) != null) {
      println(line);
    }
    println("Error message");
    while ((line = err.readLine()) != null) {
      println(line);
    }
    int rc = proc.exitValue();
    println(rc);
    System.exit(0);
  } 
  catch (IOException e) {
    println(e.getMessage());
    System.exit(-1);
  }
}