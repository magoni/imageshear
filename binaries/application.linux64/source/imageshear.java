import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class imageshear extends PApplet {

/*
imageshear
code by evan magoni 2014
*/

PImage img;
int cols, rows;

float offset;
int k;
int c;

float[] function = new float[500];
int shearHeight = 100;

public float f(float n, int a) {
  //arguments: n is x value (rotated), a is slope
  return (pow(16*n,a) / (pow(16*n,a) + pow((1 - 16*n),a)));
}

public void fillArray() {
  //creates a curve by which to offset rows
  for(int x = 0; x < (shearHeight/2) + 1; x++) {
    function[x] = f(x/(shearHeight/.1f), 4); //denominator sets point of mirroring, 2nd arg slope
  }
  
  for(int x = (shearHeight/2)+1; x < shearHeight; x++) {
    function[x] = function[(shearHeight/2)-x+(shearHeight/2)]; //reflect fn over 2nd half of array
  }
}

public void updateOffset() {
  if(k<function.length) {
    offset = mouseX/2 * function[k]; //mouseX control: amount of shearing
    k++;
  } else {
    offset=0;
  }
}

public void freezeImage() {
  loadPixels();
  img.loadPixels();
  for (int i = 0; i < rows; i++ ) {    
    for (int j = 0; j < cols; j++ ) {
      img.pixels[j + i*cols] = pixels[j + i*width]; //replace img with pixels in display window
    }
  }
  img.updatePixels();
  updatePixels();
}

public void setup() {
  img = loadImage("self.jpg");
  
  size(img.width,img.height);

  cols = img.width;
  rows = img.height;
  
  fillArray();
}

public void draw() {
  background(0);
  
  offset=0;
  k=0;
  
  img.loadPixels();
  loadPixels();
  
  for (int i = 0; i < rows; i++ ) {
    if(i>mouseY-(shearHeight/2)) updateOffset(); // mouseY control: start of shear
    
    for (int j = 0; j < cols; j++ ) {
      c = img.pixels[j + i*cols]; //grab color of original image 
      pixels[i*width + (j + (int)offset)%cols] = c; //display pixels at new location
    }
  }
  
  img.updatePixels();
  updatePixels(); 

  if(keyPressed) {
    if (key == 's') {
      saveFrame("sheared.png"); //save current display to file
    }
    //control height of shear by arrow keys (up/down) (min 70, max 500)
    if (key == CODED) {
      if(keyCode == UP && shearHeight < 500) {
        shearHeight += 10;
        fillArray();
      } else if (keyCode == DOWN && shearHeight > 70) {
        shearHeight -= 10;
        fillArray();
      }
    }
  }
}

public void mousePressed() {
  if (mouseButton == LEFT) freezeImage();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "imageshear" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
