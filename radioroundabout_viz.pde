/* --------------------------------------------------------------------------
 * Radio Roundabout: stupid visualizer
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 *        Damian Di Fede
 *        Tom Armitage glued a lot of stuff together.
 * date:  06/11/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */


import SimpleOpenNI.*;
import processing.opengl.*;
import ddf.minim.*;

Minim minim;
AudioInput in;

SimpleOpenNI context;
float        zoomF =0.3f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);
float        transX = 0;
float        transY = 0;
int          sphereRadius = 15;
int          ampMultiplier = 1000;

void setup()
{
  frameRate(10);
  size(320,240,OPENGL);
  sphereDetail(10);

  // let's set up the audio in
  minim = new Minim(this);
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);

  //context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_SINGLE_THREADED);
  context = new SimpleOpenNI(this);

  // disable mirror
  context.setMirror(false);

  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }

  if(context.enableRGB() == false)
  {
     println("Can't open the rgbMap, maybe the camera is not connected or there is no rgbSensor!"); 
     exit();
     return;
  }
  
  // align depth data to image data
  context.alternativeViewPointDepthToImage();

  stroke(255,255,255);
  smooth();
  perspective(radians(45),
              float(width)/float(height), 
              10,150000);
}

void draw()
{
  // update the cam
  context.update();

  background(0,0,0);

  translate(width/2, height/2, 0);
  translate(transX, transY, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  PImage  rgbImage = context.rgbImage();
  int[]   depthMap = context.depthMap();
  int     steps   = 5;  // to speed up the drawing, draw every fifth point
  int     index;
  PVector realWorldPoint;
  color   pixelColor;
 
  strokeWeight(steps);

  translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera

  PVector[] realWorldMap = context.depthMapRealWorld();
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0)
      { 
        // get the color of the point
        pixelColor = rgbImage.pixels[index];
        stroke(pixelColor);
        fill(pixelColor);
        
        // draw the projected point
        realWorldPoint = realWorldMap[index];
        strokeWeight(getStrokeWeight());
        point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
      }
    }
  } 
}

float getStrokeWeight() {
  float output = in.left.level() * ampMultiplier;
  if(output < 2.0) {
    return 2.0;
  } else {
    return output;
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}

void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  case '1':
    ampMultiplier = 100;
    break;
  case '2':
    ampMultiplier = 200;
    break;
  case '3':
    ampMultiplier = 300;
    break;
  case '4':
    ampMultiplier = 400;
    break;
  case '5':
    ampMultiplier = 500;
    break;
  case '6':
    ampMultiplier = 600;
    break;
  case '7':
    ampMultiplier = 700;
    break;
  case '8':
    ampMultiplier = 800;
    break;
  case '9':
    ampMultiplier = 900;
    break;
  case '0':
    ampMultiplier = 1000;
    break;
  case 'r':
    transX = 0;
    transY = 0;
    rotX = 0;
    rotY = 0;
    zoomF = 0;
    break;
  }

  switch(keyCode)
  {
  case LEFT:
    if(keyEvent.isShiftDown()) {
      transX += 5;
    } else {
      rotY += 0.1f;
    }
    break;
  case RIGHT:
    if(keyEvent.isShiftDown()) {
      transX -= 5;
    } else {
      rotY -= 0.1f;
    }
    break;
  case UP:
    if(keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if(keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if(zoomF < 0.01)
        zoomF = 0.01;
    }
    else
      rotX -= 0.1f;
    break;
  }
}

