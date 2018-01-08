// Track the point closest to the Kinect (each frame)
// and draw a line using that point and
// the previous closest point.

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

int recordValue;
int rx = 0;
int ry = 0;
int previousX;    // Declare variables for previous X/Y
int previousY;    // coordinates

void setup()
{
 size(512, 424);
 kinect2 = new Kinect2(this);
 kinect2.initDepth();
 kinect2.initDevice();
}

void draw()
{
  recordValue = 4500; 
  
  int[] depthValues = kinect2.getRawDepth();    
  for (int y = 0; y < kinect2.depthHeight; y++) 
  {
    for (int x = 0; x < kinect2.depthWidth; x++)
    {
      int i = x + y * kinect2.depthWidth;      
      int currentDepthValue = depthValues[i];
      
      if (currentDepthValue > 0 && currentDepthValue < recordValue) 
      {
        recordValue = currentDepthValue;   
        rx = x;                             
        ry = y;
      }
    }
  }    
  //image(kinect2.getDepthImage(), 0, 0);  // Draw the depth image on the screen
  
  stroke(255, 0, 0);        // Set the line color drawing to red
  line(previousX, previousY, rx, ry);  // Draw a line from previous point to the closest one
  previousX = rx;                      // Save the closest point as the previous one
  previousY = ry;  
}

void mousePressed()
{
  background(0);
}