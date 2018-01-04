// This sketch shows the depth image and RGB image
// of the Kinect 2 as two separate images.
// When a pixel is clicked on, the RGB values 
// are shown in the console.

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

void setup()
{
  size(1024, 424);
  kinect2 = new Kinect2(this);
  
  kinect2.initVideo();
  kinect2.initDepth();
  kinect2.initDevice();  // If you had multiple Kinects, add an argument for the number of each Kinect
}

void draw()
{
 background(0);
 
 PImage imgD = kinect2.getDepthImage();    // Get depth image
 PImage imgRGB = kinect2.getVideoImage();  // Get RGB image
 
 image(imgD, 0, 0);                        // Draw depth image
 image(imgRGB, kinect2.depthWidth, 0, kinect2.colorWidth*0.267, kinect2.colorHeight*0.393);  // Draw RGB image
}

void mousePressed()
{
 color c = get(mouseX, mouseY);            // Get the mouse's position
 println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));  // Convert and show RGB values of the pixel 
}                                                                 // where the mouse is when clicked.