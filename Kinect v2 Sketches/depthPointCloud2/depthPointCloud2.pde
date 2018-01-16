import org.openkinect.processing.*;    //<>//

// Kinect library object
Kinect2 kinect2;

// Angle for rotation
float a = 3.1;

void setup()
{
  size(800, 600, P3D);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
}

void draw()
{
  background(0);
  
  // Translate and rotate
  pushMatrix();
  translate(width/2, height/2, 50);
  rotateY(a);
  
  // We're just going to calculate and draw every 2nd pixel
  int skip = 2;
  
  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();
  
  stroke(255);
  strokeWeight(1);
  beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x+= skip) 
  {
    for (int y =0; y < kinect2.depthHeight; y+= skip)
    {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      // calculate the x, y, z camera position based on the depth information
      PVector point = depthToPointCloudPos(x, y, d);
      
      // Draw a point
      vertex(point.x, point.y, point.z);
    }
  }
  endShape();
  
  popMatrix();
  
  fill(255);
  text(frameRate, 50, 50);
  
  // Rotate
  //a += 0.0015;
}

// calculate the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue)
{
  PVector point = new PVector();
  point.z = (depthValue); // / (1.0f);  // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}