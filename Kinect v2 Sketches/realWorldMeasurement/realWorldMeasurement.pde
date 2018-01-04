// This sketch utilizes the Kinect's raw depth data
// to calculate the distance of objects in inches.
// To measure distance, click on an object (pixel).
// Added millimeters for better accuracy.

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

void setup()
{
  size(512, 424);
  kinect2 = new Kinect2(this);

  kinect2.initDepth();
  kinect2.initDevice();  // If you had multiple Kinects, add an argument for the number of each Kinect
}

void draw()
{
  background(0);
  PImage imgD = kinect2.getDepthImage();    // Get depth image
  image(imgD, 0, 0);                        // Draw depth image
}

void mousePressed()
{
  int[] depthValues = kinect2.getRawDepth();  // Get the raw depth as array of integers
  int clickPosition = mouseX + (mouseY * 512);    // Translate mouseX/mouseY values into a single integer to index the array.
  int millimeters = depthValues[clickPosition];  // Index depth values based on user's click position.
  
  float inches = millimeters / 25.4;       // Convert millimeters to inches
  
  println("clickPosition: " + clickPosition);
  println("mm: " + millimeters + " in: " + inches);  
}                                                                 