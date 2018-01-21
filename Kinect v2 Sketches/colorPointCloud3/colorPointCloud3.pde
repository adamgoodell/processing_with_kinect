// This sketch uses pixels from the RGB image 
// from the Kinect to color the point cloud.
// Mouse position controls the y-rotation
// of the point cloud.

import org.openkinect.processing.*;

Kinect2 kinect2;

int minThresh = 800;
int maxThresh = 1250;
float rotation = 0;

void setup()
{
  size(1024, 768, P3D);
  kinect2 = new Kinect2(this);
  // Start all data
  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();
}

void draw()
{
  background(0);
  PImage rgbImage = kinect2.getRegisteredImage();  // get the color image from the Kinect
  loadPixels();                              // load the image into the sketch for processing
  pushMatrix();

  translate(width/2, height/2, -1550);
  float mouseRotation = map(mouseX, 0, width, -180, 180);
  rotateY(radians(mouseRotation));

  int skip = 2;                              // Increase to improve frame rate

  int[] depth = kinect2.getRawDepth();
  stroke(0, 255, 255);
  strokeWeight(1);                          // Controls the density of points in the cloud
  beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x+= skip)
  {
    for (int y = 0; y < kinect2.depthHeight; y+= skip)
    {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      PVector point = depthToPointCloudPos(x, y, d);
      
      //color imageColor = rgbImage.pixels[offset];    
      //println("imageColor: " + imageColor);    // Get each pixel from RGB image and use 
      stroke(rgbImage.pixels[offset]);           // it for the stroke color of each point in the point cloud.
      vertex(point.x, point.y, point.z);
    }
  }
  endShape();
  popMatrix();
  fill(255);
  text(frameRate, 50, 50);
  //updatePixels();
  //saveFrame("take-1-#######.png");
}

// calculate the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue)
{
  PVector point = new PVector();
  point.z = depthValue;
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}