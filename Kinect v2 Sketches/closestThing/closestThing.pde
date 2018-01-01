/* This sketch uses the Kinect V2 to locate the nearest
*  object and draws a shape on top of it.
*/

import org.openkinect.processing.*;

Kinect2 kinect2; // Kinect Library object

float minThresh = 480;    // Set minimum threshold for the nearest object(s)
float maxThresh = 830;    // Set max threshold for nearest object(s)
PImage img;

void setup()
{
 size(512, 424);
 kinect2 = new Kinect2(this);
 kinect2.initDepth();            // Begin depth data
 kinect2.initDevice();           // Turn on the device
 img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
}

void draw()
{
 background(0);
 
 img.loadPixels();
 
 PImage dImg = kinect2.getDepthImage();
 //image(dImg, 0, 0);
 
 // Get the raw depth as array of integers
 int[] depth = kinect2.getRawDepth();
 
 // int record = 4500;    // Kinect V2's resolution is 4500 IR dots, so the farthest object will have a value of 4500.
 int record = kinect2.depthHeight;  // Set initial record for nearest object to be the farthest object the Kinect can see.
 int rx = 0;                        // Variables for circle's X/Y position
 int ry = 0;
 
 for (int x = 0; x < kinect2.depthWidth; x++)     // Loop through all columns in the depth data's 2D grid.
 {
  for (int y = 0; y < kinect2.depthHeight; y++)   // Loop through all rows (and columns) in the depth data.
  {
   int offset = x + y * kinect2.depthWidth;       // Offset the X/Y position of a nearby object based on the width of the depth data.
   int d = depth[offset];
   
   if (d > minThresh && d < maxThresh && x > 100 && y > 50) // If the nearest object is within the thresholds of the frame
   {
     img.pixels[offset] = color(255, 0, 150);               // Change the nearest object's color 
     
     if (y < record)                         // Compare if the new object's depth is less than previous nearby object.
     {
       record = y;                           // Set the new record for nearest to be this object.    
       rx = x;                               // Update ellipse's position based on nearest object.
       ry = y;
     }
   } else 
   {
     img.pixels[offset] = dImg.pixels[offset];  // Set offset to be the depth of the currently nearest object. 
   }
  }  
 } 
 img.updatePixels();                            // Update image
 image(img, 0, 0);
 
 fill(255);
 ellipse(rx, ry, 32, 32);                       // Draw circle on nearest object.
}