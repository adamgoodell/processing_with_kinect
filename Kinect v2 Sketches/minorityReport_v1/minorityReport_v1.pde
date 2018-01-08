// Control an image with the Kinect.
// Track the point closest to the Kinect (each frame)
// and set it to an image's position.

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

int closestValue;
int closestX = 0;
int closestY = 0;

float lastX;    
float lastY;    
float minThresh = 610;
float maxThresh = 960;

float image1X;    // Declare x-y coords for image
float image1Y;
boolean imageMoving;  // Declare a boolean to store whether or not the image is moving
PImage image1;        // Declare a variable to store the image

PImage img;

void setup()
{
 size(512, 424);
 kinect2 = new Kinect2(this);
 kinect2.initDepth();
 kinect2.initDevice();
 img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
 
 imageMoving = true;    // Start the image out moving so the mouse press will drop it 
 image1 = loadImage("image1.jpg");
 
 background(0);    
}

void draw()
{
  background(0);
  img.loadPixels();
  
  closestValue = 8000; 
  
  
  PImage dImg = kinect2.getDepthImage();
  
  int[] depthValues = kinect2.getRawDepth();    
  
  for (int x = 0; x < kinect2.depthWidth; x++) 
  {
    for (int y = 0; y < kinect2.depthHeight; y++)
    {
      int i = x + y * kinect2.depthWidth;
      int currentDepthValue = depthValues[i];

      if (currentDepthValue > minThresh && currentDepthValue < maxThresh) 
      {
        img.pixels[i] = color(255, 0, 150);
        
        if (y < closestValue)
        {
          closestValue = y;
          closestX = x;                             
          closestY = y;          
        } 
        else
        {
          img.pixels[i] = dImg.pixels[i];
        }
      }
    }
  }    
  img.updatePixels();
  image(img, 0, 0);
  
  float interpolatedX = lerp(lastX, closestX, 0.3);
  float interpolatedY = lerp(lastY, closestY, 0.3);
  
  background(0);    // Clear the previous drawing
  
  if (imageMoving)  // Only update image position if image is in moving state  
  {
    image1X = interpolatedX;
    image1Y = interpolatedY;
  }
  
  image(image1, image1X, image1Y);    // draw the image on the screen
  
  lastX = interpolatedX;                     
  lastY = interpolatedY;  
}

void mousePressed()
{                              // if the image is moving, drop it
  imageMoving = !imageMoving;  // if the image is dropped, pick it up
}