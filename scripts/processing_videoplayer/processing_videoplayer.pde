import gohai.glvideo.*;
import processing.io.*;
import oscP5.*;

OscP5 oscP5;

GLMovie video1;
GLMovie video2;

boolean restart = false; // restart video on each change
float distance = 0; // incoming sensor
String currentVideo = "A"; // video A or B
float triggerDistance = 100; //cm
float timeLimit = 2; //seconds
float timeStamp = 0; //last change time

void setup() {
  //size(560, 203, P2D);
  fullScreen(P2D);
  
  oscP5 = new OscP5(this,7000);
  
  setupVideos();
  
}

void draw() {
  
  background(0);
  
  
  if (millis() - timeStamp > timeLimit) {
    
    if ((distance < triggerDistance)&&(currentVideo != "A")) {
      
      timeStamp = millis();
      currentVideo = "A";
    }
    if ((distance >= triggerDistance)&&(currentVideo != "B")) {
      
      timeStamp = millis();
      currentVideo = "B";
    }
    
  }
  
  
  if (video1.available()) {
    video1.read();
  }
  if (video2.available()) {
    video2.read();
  }
  
  
  if (currentVideo == "A") image(video1, 0, 0, width, height);
  if (currentVideo == "B") image(video2, width, 0, width, height);
  
  
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
  
  if (msg.checkAddrPattern("/Ultrasonic")) {
    println("Ultrasonic", msg.get(0).floatValue());
    distance =  msg.get(0).floatValue();
    
  }
}

void setupVideos() {
  
  int maxVideos = 2;
  String[] whereToLook = {"~/Video", "/media/pi/USB"};
  File[] videos = fetchVideoFiles(whereToLook, maxVideos);
  
  for (int i = 0; i < videos.length; i++) {
      
    File f = videos[i]; 
    if (f != null) println(f.getName());
  }
  
  if (videos[0] != null && videos[1] != null) {
  
    video1 = new GLMovie(this, videos[0].getAbsolutePath(), GLVideo.MUTE);
    video2 = new GLMovie(this, videos[1].getAbsolutePath(), GLVideo.MUTE);
    video2.jump(2.0);
    video1.loop();
    video2.loop();
  
  } else {
    println("No Videos");
  }
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
