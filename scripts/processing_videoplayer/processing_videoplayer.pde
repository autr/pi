import gohai.glvideo.*;
import processing.io.*;

GLMovie video1;
GLMovie video2;

int triggerPin = 12;
int echoPin = 11;

float startTime = 0;
float endTime = 0;

String[] searchLocations = {"~/Video", "/Users/gilbertsinnott/Google Drive/-- Autr --/-- Videos --/__Instas/", "/media"};
File[] videos = new File[2];

void setup() {
  size(560, 203, P2D);
  
  //fullScreen)
  
  int count = 0;
  for (int i = 0; i < searchLocations.length; i++) {
     File[] files = listFiles(searchLocations[i]);
     if (files != null) {
       for (int ii = 0; ii < files.length; ii++) {
          File f = files[ii];    
          String n = f.getName();
          String p = f.getAbsolutePath();
          
          if (n.endsWith(".mov")||n.endsWith(".mp4")) {
            if (count < 2 ) {
              videos[count] = f;
              count += 1;
            }
          }
       }
     }
  }
  
  for (int i = 0; i < videos.length; i++) {
      
    File f = videos[i];    
    println(f.getName());
    
  }
  
  video1 = new GLMovie(this, videos[0].getAbsolutePath(), GLVideo.MUTE);
  video2 = new GLMovie(this, videos[1].getAbsolutePath(), GLVideo.MUTE);
  video2.jump(2.0);
  video1.loop();
  video2.loop();
  
  println("Waiting for sensor to settle");
  /*-- GPIO --*/
  
  GPIO.pinMode(triggerPin, GPIO.OUTPUT);
  GPIO.pinMode(echoPin, GPIO.INPUT);
  
  GPIO.digitalWrite(triggerPin, GPIO.LOW);
  delay(2000);
  
}


void draw() {
  
  //println("HEY");
  
  GPIO.digitalWrite(triggerPin, GPIO.HIGH);
  delay(1);
  GPIO.digitalWrite(triggerPin, GPIO.LOW);
  
  while(GPIO.digitalRead(echoPin) == 0) startTime = millis();
  while(GPIO.digitalRead(echoPin) == 1) endTime = millis();
  
  float duration = endTime - startTime;
  float distance = duration * 17150;
  
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
