/*
code by evan magoni 2014
rev 2014-02-17

TODO: * fix line
      * make wrap smoother
      * interactivity / use beziers?
*/

PImage img;
int cols, rows;

float offset;
int k;

  int x, y;
color c;

float[] function = new float[100];

float f(float n, int a) {
  //arguments: n is x value (rotated), a is slope
  return (pow(16*n,a) / (pow(16*n,a) + pow((1 - 16*n),a)));
}

void fillArray() {
  //creates a curve by which to offset rows
  for(int x = 0; x < (function.length/2) + 1; x++) {
    function[x] = f(x/(function.length/.1), 4); //denominator sets point of mirroring, 2nd arg slope
  }
  
  for(int x = (function.length/2)+1; x < function.length; x++) {
    function[x] = function[(function.length/2)-x+(function.length/2)]; //reflect fn over 2nd half of array
  }
}

public void updateOffset() {
  if(k<function.length) {
    offset = mouseX/2 * function[k];
    k++;
  } else {
    offset=0;
  }
}

public void setup() {
  img = loadImage("self.jpg");
  
  size(img.width,img.height);

  cols = img.width;
  rows = img.height;
  
  fillArray();

  //noLoop();
}

public void draw() {
  background(0);
  
  offset=0;
  k=0;
  
  img.loadPixels();
  loadPixels();
  
  for (int i = 0; i < rows; i++ ) {
    
    if(i>mouseY) updateOffset();
    
    for (int j = 0; j < cols; j++ ) {
      x = j; // x position
      y = i; // y position
      c = img.pixels[x + y*cols]; //grab color of original image 
      
      pixels[y*width + (x + (int)offset)%cols] = c; //display pixels at new location
    }
  }
  
  img.updatePixels();
  updatePixels();
}
