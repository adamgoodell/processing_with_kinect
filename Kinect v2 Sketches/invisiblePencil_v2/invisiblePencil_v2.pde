// Track the point closest to the Kinect (each frame)
// and draw a line using that point and
// the previous closest point.
// UPDATE: Added smoother lines, saving images.
// Kinect v2 mirrors the depth image by default.

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

int closestValue;
int closestX = 0;
int closestY = 0;

float lastX;    // Need floats for smooth interpolation
float lastY;    

void setup()
{
 size(512, 424);
 kinect2 = new Kinect2(this);
 kinect2.initDepth();
 kinect2.initDevice();
 
 background(0);    // Start out with a black background
}

void draw()
{
  closestValue = 4500; 
  
  int[] depthValues = kinect2.getRawDepth();    
  for (int y = 0; y < kinect2.depthHeight; y++) 
  {
    for (int x = 0; x < kinect2.depthWidth; x++)
    {
      
      // reversedX is unnecessary w/ Kinect2 as the image is mirrored by default
      //int reversedX = kinect2.depthWidth - x - 1;  // Reverse the x by moving in the from the right side of the image 
      
      //int i = reversedX + y * kinect2.depthWidth;  // Use reversedX to calculate the array index
      int i = x + y * kinect2.depthWidth;
      int currentDepthValue = depthValues[i];
      
      // Only look for the closestValue within a range 
      // 610 (or 2 feet) is the minimum
      // 1525 (or 5 feet) is the maximum
      if (currentDepthValue > 710 && currentDepthValue < 1225 && currentDepthValue < closestValue) 
      {
        closestValue = currentDepthValue;   
        closestX = x;                             
        closestY = y;
      }
    }
  }    
  
  // "linear interpolation", i.e. smooth transition between last point and new closest point
  float interpolatedX = lerp(lastX, closestX, 0.3);
  float interpolatedY = lerp(lastY, closestY, 0.3);
  
  stroke(0, 255, 0); 
  strokeWeight(3);    // Make the line thicker to look nicer
  
  //image(kinect2.getDepthImage(), 0, 0);
  
  line(lastX, lastY, interpolatedX, interpolatedY);  
  lastX = interpolatedX;                     
  lastY = interpolatedY;  
}

void mousePressed()
{
  saveFrame("line-######.png");  // Save image to a file then clear it on the screen
  background(0);
}