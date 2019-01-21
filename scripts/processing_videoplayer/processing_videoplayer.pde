import gohai.glvideo.*;
import processing.io.*;
import oscP5.*;

OscP5 oscP5;

GLMovie video1;
GLMovie video2;

float distance = 0; // incoming sensor
float triggerDistance = 0; //cm
float smoothing = 0.9;

float timeLimit = 1000; //seconds
float timeStamp = 0; // last change time

String currentVideo = "A"; // video A or B
String proposedVideo = "A";

boolean isReceiving = false;
float receivingTimestamp = 0;
boolean isCalibrated = false;

boolean showOverlay = false;

PFont f;

void setup() {

  fullScreen(P2D);

  oscP5 = new OscP5(this,7000);
  
  /*-- Search for videos --*/

  int maxVideos = 2;
  String[] whereToLook = {"~/Video", "/media/pi/USB"};
  File[] videos = fetchVideoFiles(whereToLook, maxVideos);
  
  for (int i = 0; i < videos.length; i++) {
    File f = videos[i];
  }
  
  if (videos[0] != null && videos[1] != null) {
  
    String pathA = videos[0].getAbsolutePath();
    String pathB = videos[1].getAbsolutePath();

    video1 = new GLMovie(this, pathA, GLVideo.MUTE);
    video2 = new GLMovie(this, pathB, GLVideo.MUTE);

    video1.loop();
    video2.loop();

    println("Using videos", pathA, pathB);
  
  } else {
    println("No Videos");
  }

  f = createFont("Arial",32,true); 
  
}

void draw() {
  
  background(0);
  textFont(f,32);
  fill(255);  

  /*-- 1) No OSC messages received yet ... --*/

  if (!isReceiving) {

    text("Waiting for OSC...",100,100);

    return;
  }

  /*-- 2) Calibrating triggerDistance with incoming values --*/

  if (isReceiving && !isCalibrated) {

    triggerDistance += distance;
    triggerDistance /= 2;

    text("Calibrating trigger distance: " + str(triggerDistance) + "cm",100,100);

    if (millis() - receivingTimestamp > 10000) isCalibrated = true;

    return;
  }

  /*-- 3) Playback videos --*/
  
  
    
  if ((distance < triggerDistance)&&(proposedVideo != "A")) {
    
    timeStamp = millis();
    proposedVideo = "A";
  }

  if ((distance > triggerDistance)&&(proposedVideo != "B")) {
    timeStamp = millis();
    proposedVideo = "B";
  }
    
  if (millis() - timeStamp > timeLimit) {
    if (proposedVideo != currentVideo) {
      currentVideo = proposedVideo;
      println("Trigger", currentVideo);
    }
  }
  
  
  if (video1.available()) video1.read();
  if (video2.available()) video2.read();
  
  if (currentVideo == "A") {
    image(video1, 0, 0, width, height);
    video1.volume(1);
    video2.volume(0);
  }
  if (currentVideo == "B") {
    image(video2, 0, 0, width, height);
    video1.volume(0);
    video2.volume(1);
  }

  text("Trigger distance: " + str(round(triggerDistance)) + "cm",100,100);
  text("Current distance: " + str(round(distance)) + "cm",100,200);
  text("Current video: " + currentVideo,100,300);

  fill(0);
  rect(100, 400, width - 200, 60);
  fill(255);
  rect(110, 410, distance, 40);
}

void oscEvent(OscMessage msg) {
  
  if (msg.checkAddrPattern("/Ultrasonic")) {

    if (!isReceiving) {
      distance = msg.get(0).floatValue();
      triggerDistance = distance;
      isReceiving = true;
      receivingTimestamp = millis();
    }

    distance =  (distance * smoothing) + (msg.get(0).floatValue() * (1 - smoothing));
  }
}
void keyPressed() {
  showOverlay = !showOverlay;
}


File[] fetchVideoFiles(String[] searchLocations, int maximum) {
  
  File[] vids = new File[maximum]; // Prepopulate array
  int count = 0; // Counter for each video
  
  /*-- Loop over each search location --*/
  
  for (int i = 0; i < searchLocations.length; i++) {
     File[] files = listFiles(searchLocations[i]);
     //ArrayList<File> allFiles = listFilesRecursive("/test");
     if (files != null) {
       
       /*-- Loop over each file --*/
       
       for (int ii = 0; ii < files.length; ii++) {
          File f = files[ii];    
          String n = f.getName();
          String p = f.getAbsolutePath();
          
          /*-- Check if file is a video --*/
          
          if (n.endsWith(".mov")||n.endsWith(".mp4")) {
            
            /*-- Make sure we are within maximum --*/
            
            if (count < maximum ) {
              vids[count] = f;
              count += 1;
            }
          }
       }
     }
  }
  return vids;
}