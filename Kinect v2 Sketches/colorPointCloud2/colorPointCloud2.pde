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
  kinect2.initVideo();
  kinect2.initDepth();
  kinect2.initIR();
  kinect2.initRegistered();
  kinect2.initDevice();
}

void draw()
{
  background(0);
  PImage rgbImage = kinect2.getRegisteredImage();  // load the color image from the Kinect

  pushMatrix();

  translate(width/2, height/2, -1050);
  //translate(0, 0, 1000);
  rotateY(radians(rotation));
  //rotation++;

  int skip = 2;

  int[] depth = kinect2.getRawDepth();
  stroke(0, 255, 255);
  beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x+= skip)
  {
    for (int y = 0; y < kinect2.depthHeight; y+= skip)
    {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      
      if (d < minThresh)
      {
        stroke(255, 0, 0);  
      }
      
      if (d > minThresh && d < maxThresh) {
          stroke(226, 255, 10); 
      } 
      if (d > maxThresh) {
        stroke(0, 255, 255);
      }
              PVector point = depthToPointCloudPos(x, y, d);
      
        //for (int i = 0; i < depth.length; i++) {
        //stroke(rgbImage.pixels[y]);
        //println(rgbImage.pixels[y]);        
        //}
        vertex(point.x, point.y, point.z);  
      
    }
  }
  endShape();
  popMatrix();
  fill(255);
  text(frameRate, 50, 50);
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