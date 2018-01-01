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
 
 PImage img = kinect2.getDepthImage();
 image(img, 0, 0);
}