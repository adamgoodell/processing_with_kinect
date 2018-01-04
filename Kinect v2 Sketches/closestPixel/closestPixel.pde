import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

int recordValue;
int rx = 0;
int ry = 0;

void setup()
{
 size(512, 424);
 kinect2 = new Kinect2(this);
 kinect2.initDepth();
 kinect2.initDevice();
}

void draw()
{
  recordValue = 4500;  // Kinect V2's resolution is 4500 IR dots, so the farthest object will have a value of 4500.
  
  int[] depthValues = kinect2.getRawDepth();    // Get the depth array from the Kinect
  
  for (int y = 0; y < kinect2.depthHeight; y++)  // For each row in the depth image
  {
    for (int x = 0; x < kinect2.depthWidth; x++)
    {
      int i = x + y * kinect2.depthWidth;      // Pull out the corrsponding value from depth array
      int currentDepthValue = depthValues[i];
      
      if (currentDepthValue > 0 && currentDepthValue < recordValue) // if that pixel is the closest one we've seen so far
      {
        recordValue = currentDepthValue;    // Save its value
        rx = x;                             // And save its x and y coordinates
        ry = y;
      }
    }
  }    
  image(kinect2.getDepthImage(), 0, 0);  // Draw the depth image on the screen
  
  fill(0, 255, 0);          // Draw a green circle over it
  ellipse(rx, ry, 25, 25);  // positioned at the X/Y coordinates we saved from the closest pixel. 
}