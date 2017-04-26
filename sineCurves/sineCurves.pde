/** ELG 2336 - Project: AXIDRAW - 2D Plotter ***
************************************************ 
*** Sine Curve Representation of Images ********
************************************************
*** Created by Omar Husain *********************
*** Date: March 27, 2017 ***********************
***********************************************/

import processing.pdf.*;

PShape line;
PShape s;
PImage img;

float maxAmpl = 4;
int xstep = 6;
int numofLines = 60;

void setup(){
  img = loadImage("Rachel-Carson.jpg");
  img.filter(GRAY);
  surface.setSize(img.width,img.height);
  //background(255);
  noLoop();
}

void draw(){
  background(255);
  beginRecord(PDF, "Rachel-Carson.pdf");
  int ystep = img.height/(numofLines*2);
  float b = 0.0;
  int pos = 0;
  int outPos = 0;
  float freq=0.0;
  float sineVal = 0.0;
  float prev_x = 0.0;
  float prev_y = 0.0;
  float ampl = 0.0;
  stroke(0);
  noFill();
  s = createShape(GROUP);
  
  // iterate through pixels
  for(int y = 0; y<img.height;y+=ystep){
    line = createShape(PShape.PATH);
    line.beginShape();
    for(int x = 0; x<img.width;x+=xstep){
        pos = x+y*img.width;
        b = brightness(img.pixels[pos]);
        // generate frequency & amplitude given brightness of pixel
        b= threshold(b);
        freq = freq(b);
        ampl = ampl(freq);
        line.vertex(prev_x,prev_y);
        // compute sine curve for this pixel
        for(int z=x;z<x+xstep;z++){
          sineVal = ampl*sin(TWO_PI*freq*z/500)+y;
          line.vertex(z,sineVal);
          prev_y = sineVal;
        }
        prev_x = x+xstep-1;
    }
    line.endShape();
    s.addChild(line);
    prev_y = sineVal+ystep;
    prev_x = 0.0;
  }
  shape(s);
  println("done");
  endRecord();
  exit();
}

float freq(float avgB){
  float minB = 40, maxB = 254;
  avgB = max(minB,avgB);
  float freq = max(maxB-avgB,0);
  return freq;
}

float threshold(float Br){
  float minBr = 210, maxBr = 255;
  float threshold = Br;
  if(threshold>minBr){
     threshold = maxBr;    
  }
  return threshold;
}

float ampl(float freq){
  float ampl = maxAmpl*log(freq+1);
  if(ampl>maxAmpl){
    ampl = maxAmpl;  
  }
  return ampl;
}