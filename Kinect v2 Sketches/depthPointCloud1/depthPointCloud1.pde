import org.openkinect.processing.*;
import java.nio.FloatBuffer;

Kinect2 kinect2;

// Angle for rotation
float a = 0;

// Change render mode between openGL and CPU
int renderMode = 1;

// for openGL render
PGL pgl;
PShader sh;
int vertLoc;

void setup()
{
  size(800, 600, P3D);  // Rendering in P3D 
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  // load shaders
  sh = loadShader("frag.glsl", "vert.glsl");

  smooth(16);
}

void draw()
{
  background(0);
  //fill(0, 10);
  //rect(0, 0, width, height);

  // Translate and rotate
  pushMatrix();
  translate(width/2, height/2, -1000);  // prepare to draw centered in x-y and pull it 1000 pixels closer on the z
  rotateY(a);  // flip y-axis from "realWorld"
  stroke(255);

  if (renderMode == 1) {

    // We're just going to calculate and draw every 2nd pixel
    int skip = 2;

    // Get the raw depth as array of integers
    int[] depth= kinect2.getRawDepth();

    stroke(255);
    beginShape(POINTS);
    for (int x = 0; x < kinect2.depthWidth; x+= skip) 
    {
      for (int y = 0; y < kinect2.depthHeight; y+= skip) 
      {
        int offset = x + y * kinect2.depthWidth;

        // calculate the x, y, z, camera position based on the depth information
        PVector point = depthToPointCloudPos(x, y, depth[offset]);

        // Draw a point
        vertex(point.x, point.y, point.z);
      }
    }

    endShape();    
  } else if ( renderMode == 2) {
    // geth the depth data as a FloutBuffer
    FloatBuffer depthPositions = kinect2.getDepthBufferPositions();

    pgl = beginPGL();
    sh.bind();

    vertLoc = pgl.getAttribLocation(sh.glProgram, "vertex");

    pgl.enableVertexAttribArray(vertLoc);

    // color for each POINT of the point cloud
    sh.set("fragColor", 1.0, 1.0, 1.0, 1.0);

    pgl.enableVertexAttribArray(vertLoc);

    // data size
    int vertData = kinect2.depthWidth * kinect2.depthHeight;

    pgl.vertexAttribPointer(vertLoc, 3, PGL.FLOAT, false, 0, 1);
    pgl.drawArrays(PGL.POINTS, 0, vertData);

    sh.unbind();
    endPGL();
  }
  popMatrix();

  fill(255, 0, 0);
  text(frameRate, 50, 50);

  // Rotate
  //a += 0.0015;
}

void keyPressed()
{
  if (key == '1') {
    renderMode = 1;
  }
  if (key == '2') {
    renderMode = 2;
  }
}

// calculate the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);  // / (1.0);  // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}