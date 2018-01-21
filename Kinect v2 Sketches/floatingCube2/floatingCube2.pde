// This sketch is an interface using
// a point cloud that interacts
// with a cube.


import org.openkinect.processing.*;

Kinect2 kinect2;

float rotation = 0;
int boxSize = 150;    // set the box size
PVector boxCenter = new PVector(0, 0, 600);  // a vector holding the center of the box

float s = 1;      // This will be used for zooming. Start at normal.

void setup()
{
  size(1024, 768, P3D);
  //fullScreen(P3D);
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

  translate(width/2, height/2, -1000);
  float mouseRotation = map(mouseX, 0, width, -180, 180);

  translate(0, 0, -1400);            // Increased the translation to center the scale better 
  rotateY(radians(mouseRotation));

  translate(0, 0, s*-1000);        // Make everything bigger, i.e. zoom in.
  scale(s);
  println(s);
  
  int depthPointsInBox = 0;       // a variable for storing the total points we find inside the box on this frame
  int skip = 3;                              // Increase to improve frame rate

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
      
      // The nested if statements inside our loop
      if (point.x > boxCenter.x - boxSize/2 && point.x < boxCenter.x + boxSize/2)
      {
        if (point.y > boxCenter.y - boxSize/2 && point.y < boxCenter.y + boxSize/2)
        {
          if (point.z > boxCenter.z - boxSize/2 && point.z < boxCenter.z + boxSize/2)
          {
            depthPointsInBox++;  
          }
        }
      }
      vertex(point.x, point.y, point.z);
    }
  }
  endShape();
  println(depthPointsInBox);
  
  // Set the box color's transparency
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);  // 0 is transparent, 1000 is fully opaque red
  
  translate(boxCenter.x, boxCenter.y, boxCenter.z);
  fill(255, 0, 0, boxAlpha);    // set the box's alpha based on the mapped value
  
  stroke(255, 0, 0);                                // set line color to red
  //strokeWeight(5);
  box(boxSize);                    // draw the box
  
  popMatrix();
  fill(255);
  text(frameRate, 50, 50);
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

// Use arrow keys to control zoom
// Up arrow zooms in
// Down arrow zooms out 
// s gets passed to scale() in draw() 
void keyPressed()
{
  if (keyCode == 38) 
  {
    s = s + 0.01;  
  }
  
  if (keyCode == 40)
  {
    s = s - 0.01;  
  }
}

void mousePressed()
{
  save("touchedPoint.png");  
}