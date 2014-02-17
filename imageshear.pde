/*
code by evan magoni 2014
rev 2014-02-17

TODO: * fix line
      * implement wrap
*/

PImage img;
int cols, rows;

float counter;
int k;

//------------- bullshit function functions ------------- 
float[] function = new float[100];

float f(float n, int a) {
  //arguments: n is x value, a is slope
  return (pow(16*n,a) / (pow(16*n,a) + pow((1 - 16*n),a)));
}

void fillArray() {
  for(int x = 0; x < function.length/2; x++) {
    function[x] = f(x/(function.length/.1), 4); // messing with the denominator sets point of mirroring, 2nd arg slope
  }
  
  for(int x = (function.length/2) + 1; x < function.length; x++) {
    function[x] = function[(function.length/2)-x+(function.length/2)];
  }
}

//-----------  end bullshit function functions ----------- 

public void setup() {
  size(1000,800);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("self.jpg");
  cols = img.width;
  rows = img.height;
  
  fillArray(); // bullshit function function
  
  noLoop();
}

public void updateCounter() {
  if(k<function.length) {
    //counter = 100 * sin(radians(k));
    counter = 100 * function[k];
    k++;
  } else {
    counter=0;
  }
}

public void draw() {
  background(0);
  img.loadPixels();

  counter=0;
  k=0;
  
  // Begin loop for rows
  for (int i = 0; i < rows; i++ ) {

    if(i>140) updateCounter();

    // Begin loop for columns
    for (int j = 0; j < cols; j++ ) {
      int x = j; // x position
      int y = i; // y position
      int loc = x + y*cols;           // Pixel array location
      color c = img.pixels[loc];       // Grab the color

      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();

      translate((x + (int)counter), y);
      
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(0,0,2,2);
      popMatrix();
    }

  }
  img.updatePixels();
}
