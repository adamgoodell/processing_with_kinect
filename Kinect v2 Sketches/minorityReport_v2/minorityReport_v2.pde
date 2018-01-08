// Control multiple images with the Kinect.
// Track the point closest to the Kinect (each frame)
// and set it to an image's position.
// Use the closest point's depth value to 
// scale the current image.
// Press any button on keyboard to freeze all images in place
// and save the current frame. Each image starts at a set position.

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

int closestValue;
int closestX;
int closestY;

float lastX;    
float lastY;    
float minThresh = 600;
float maxThresh = 930;

float image1X = width * 0.25;    // Declare x-y coords for image
float image1Y = height * 0.4;
float image1scale;      // Declare variables for image scale
int image1width = 250;  // and dimensions
int image1height = 250;

float image2X = width * 0.5;
float image2Y = height * 0.4;
float image2scale;
float image2width = 250;
float image2height = 250;

float image3X = width * 0.75;
float image3Y = height * 0.4;
float image3scale;
float image3width = 250;
float image3height = 250;

int currentImage = 1;  // Keep track of which image is moving
PImage image1;        // Declare variables to store the images
PImage image2;    
PImage image3;

PImage img;

void setup()
{
  size(512, 424);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);

  image1 = loadImage("image1.jpg");
  image2 = loadImage("image2.jpg");
  image3 = loadImage("image3.jpg");
}

void draw()
{
  background(0);
  closestValue = 8000; 
  img.loadPixels();  

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
  //img.updatePixels();
  //image(img, 0, 0);

  float interpolatedX = lerp(lastX, closestX, 0.3);
  float interpolatedY = lerp(lastY, closestY, 0.3);

  switch (currentImage)    // Select the current image
  {
  case 1:                   // Update its x-y coords
    image1X = interpolatedX;  // from the interpolated coords
    image1Y = interpolatedY;  // Update its scale from closestValue
    image1scale = map(closestValue, minThresh, maxThresh, 0, 4);  // 0 means invisible, 4 means quadruple size
  break;

  case 2:
    image2X = interpolatedX;
    image2Y = interpolatedY;
    image2scale = map(closestValue, minThresh, maxThresh, 0, 4);
  break;

  case 3:
    image3X = interpolatedX;
    image3Y = interpolatedY;
    image3scale = map(closestValue, minThresh, maxThresh, 0, 4);
  break;
  }
  
  // Draw all the images on the screen. 
  // Use their saved scale variables to set their dimesions.  
  image(image1, image1X, image1Y, image1width * image1scale, image1height * image1scale);
  image(image2, image2X, image2Y, image2width * image2scale, image2height * image2scale);
  image(image3, image3X, image3Y, image3width * image3scale, image3height * image3scale);
  
  lastX = interpolatedX;                     
  lastY = interpolatedY;
  
  
}

void mousePressed()
{                              // if the image is moving, drop it
  currentImage++;    // Increase current image
  if (currentImage > 3)
  {
    currentImage = 1; 
  }
  println(currentImage);
}

void keyPressed()    // Freeze all images on keyboard press
{
  currentImage = 0;
  saveFrame("line-######.png");
}