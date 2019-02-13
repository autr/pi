import gohai.glvideo.*;
import processing.io.*;
import oscP5.*;

OscP5 oscP5;

GLMovie video1;
GLMovie video2;

float oscTimestamp = 0;
boolean disableVideo = false;

float distance = 0; // incoming sensor
float triggerDistance = 0; //cm
float smoothing = 0.8;

float timeLimit = 3000; //milliseconds
float timeStamp = 0; // last change time

String currentVideo = "A"; // video A or B
String proposedVideo = "A";

boolean isReceiving = false;
float receivingTimestamp = 0;
float calibratedTimestamp = 0;
boolean isCalibrated = false;

boolean isShowingInformation = true;


int triggerPin = 12;
int echoPin = 11;

float startTime = 0;
float endTime = 0;
float distGPIO = 0;

PFont f;

void setup() {

  fullScreen(P2D);
  
  //Process p = exec("/usr/bin/python /home/pi/pi/scripts/ultrasonic_osc.py"); 
  //size(200,200, P2D);

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

  if (!disableVideo) {

    video1 = new GLMovie(this, pathA, GLVideo.MUTE);
    video2 = new GLMovie(this, pathB, GLVideo.MUTE);

    video1.loop();
    video2.loop();
  }

    println("Using videos", pathA, pathB);
  
  } else {
    println("No Videos");
  }

  f = createFont("Arial",32,true); 

  
}

void getDistance() {

  GPIO.digitalWrite(triggerPin, GPIO.HIGH);
  delay(1);
  GPIO.digitalWrite(triggerPin, GPIO.LOW);

  while(GPIO.digitalRead(echoPin) == 0) startTime = millis();
  while(GPIO.digitalRead(echoPin) == 1) endTime = millis();

  delay(50);
  distGPIO = (endTime - startTime) * 17150;
}

void draw() {



  
  background(0);
  textFont(f,32);
  fill(255); 


  if (millis() - oscTimestamp > 4000) {
    println("None", oscTimestamp);
    distance =  (distance * smoothing) + (400.0 * (1 - smoothing));
  }


  /*-- 1) No OSC messages received yet ... --*/

  if (!isReceiving) {

    text("Waiting for OSC...",100,100);

    return;
  }

  /*-- 2) Calibrating triggerDistance with incoming values --*/

  if (isReceiving && !isCalibrated) {

    triggerDistance += distance;
    triggerDistance /= 2;

    text("Calibrating trigger distance: " + str(round(triggerDistance)) + "cm",100,100);

    if (millis() - receivingTimestamp > 10000) {
      isCalibrated = true;
      triggerDistance -= 2;
      calibratedTimestamp = millis();
    }

    return;
  }

  /*-- 3) Get video A or B - needs 2 seconds of consistent distance to switch --*/

    
  if ( (millis() - timeStamp) > timeLimit) {

    if ((distance < triggerDistance)&&(currentVideo != "A")) {
      timeStamp = millis();
      currentVideo = "A";
    }

    if ((distance >= triggerDistance)&&(currentVideo != "B")) {
      timeStamp = millis();
      currentVideo = "B";
    }
  }

  /*-- 4) Show information --*/


  if (isShowingInformation) {

    text("Trigger distance: " + str(round(triggerDistance)) + "cm",100,100);
    text("Current distance: " + str(round(distance)) + "cm",100,200);

    fill(0);
    rect(100, 260, width - 200, 60);
    fill(255);
    rect(110, 270, distance, 40);
    fill(255, 0, 0);
    rect(100 + triggerDistance - 2, 260, 4, 60);

    fill(255);
    text("Current video: " + currentVideo,100,400);
    
    
    if (millis() - oscTimestamp < 500) {
    
      text("Live distance: " + str(distance) + "cm",100,500);
    }


    //if (millis() - calibratedTimestamp > 20000) {
    //  // isShowingInformation = false;
    //}

    return;
  }

  /*-- 5) Playback videos --*/
  
  if (!disableVideo) {
  
    if (video1.available()) video1.read();
    if (video2.available()) video2.read();
    
    if (currentVideo == "A") {
      // video1.play();
      // video2.pause();
      image(video1, 0, 0, width, height);
      video1.volume(1);
      video2.volume(0);
    }
    if (currentVideo == "B") {
      // video1.pause();
      // video2.play();
      image(video2, 0, 0, width, height);
      video1.volume(0);
      video2.volume(1);
    }
  }

}

void oscEvent(OscMessage msg) {
  
  if (msg.checkAddrPattern("/Ultrasonic")) {

    if (!isReceiving) {
      distance = msg.get(0).floatValue();
      triggerDistance = distance;
      isReceiving = true;
      receivingTimestamp = millis();
    }
    
    oscTimestamp = millis();
    println("get timestamp", oscTimestamp);

    distance =  (distance * smoothing) + (msg.get(0).floatValue() * (1 - smoothing));
  }
  if (msg.checkAddrPattern("/Button")) {
    isShowingInformation = !isShowingInformation;
    
  }
}

void stop() {
    video1.close();
    video2.close();
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
