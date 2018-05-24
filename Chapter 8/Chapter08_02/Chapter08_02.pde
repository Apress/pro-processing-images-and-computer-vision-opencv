// Shutdown computer, OSX version
import java.lang.Process;
import java.lang.Runtime;
import java.io.*;
import java.util.Arrays;

String comm;
String pw;

void setup() {
  size(640, 480);
  // Shutdown command
  comm = "sudo -S shutdown -h now";
  pw = "password";
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
    BufferedWriter out = new BufferedWriter(
      new OutputStreamWriter(proc.getOutputStream()));
    char [] pwc = pw.toCharArray();
    // Send out the sudo password.
    out.write(pwc);
    out.write('\n');
    out.flush();
    // Erase the password.
    Arrays.fill(pwc, '\0');
    pw = "";
    // Print out messages.
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