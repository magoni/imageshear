/*
code by evan magoni 2014
*/

PImage img, newimg;
int cols, rows;

float offset;
int k, x, y;
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
    if(i>mouseY) updateOffset(); // mouseY control: start of shear
    
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
  }
}

void mousePressed() {
  freezeImage();
}
