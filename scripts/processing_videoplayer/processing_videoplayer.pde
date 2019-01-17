import gohai.glvideo.*;
import processing.io.*;

GLMovie video1;
GLMovie video2;

int TRIGGER_PIN = 12;
int ECHO_PIN = 11;

float startTime = 0;
float endTime = 0;

void setup() {
  size(560, 203, P2D);
  
  
  int maxVideos = 2;
  String[] whereToLook = {"~/Video", "/media"};
  File[] videos = fetchVideoFiles(whereToLook, maxVideos);
  
  for (int i = 0; i < videos.length; i++) {
      
    File f = videos[i]; 
    if (f != null) println(f.getName());
  }
  
  video1 = new GLMovie(this, videos[0].getAbsolutePath(), GLVideo.MUTE);
  video2 = new GLMovie(this, videos[1].getAbsolutePath(), GLVideo.MUTE);
  video2.jump(2.0);
  video1.loop();
  video2.loop();
  
  println("Waiting for sensor to settle");
  /*-- GPIO --*/
  
  GPIO.pinMode(TRIGGER_PIN, GPIO.OUTPUT);
  GPIO.pinMode(ECHO_PIN, GPIO.INPUT);
  
  GPIO.digitalWrite(TRIGGER_PIN, GPIO.LOW);
  delay(2000);
  
}


void draw() {
  
  float distance = getUltrasonicDistance(TRIGGER_PIN, ECHO_PIN);
  println( "Distance", round(distance) );
  
  background(0);
  
  //if (video1.available()) {
  //  video1.read();
  //}
  //if (video2.available()) {
  //  video2.read();
  //}
  //image(video1, 0, 0, width/2, height);
  //image(video2, width/2, 0, width/2, height);
}


float getUltrasonicDistance(int triggerPin, int echoPin) {

  GPIO.digitalWrite(triggerPin, GPIO.HIGH);
  delay(1);
  GPIO.digitalWrite(triggerPin, GPIO.LOW);
  
  while(GPIO.digitalRead(echoPin) == 0) startTime = millis();
  while(GPIO.digitalRead(echoPin) == 1) endTime = millis();
  
  float duration = endTime - startTime;
  float distance = duration * 17150;
  return distance;
}

File[] fetchVideoFiles(String[] searchLocations, int maximum) {
  
  File[] vids = new File[maximum]; // Prepopulate array
  int count = 0; // Counter for each video
  
  /*-- Loop over each search location --*/
  
  for (int i = 0; i < searchLocations.length; i++) {
     File[] files = listFiles(searchLocations[i]);
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
