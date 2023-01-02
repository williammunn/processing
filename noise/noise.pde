int arraySize = 200;
float[] x;
float[] y;
float speed = 5;

void setup() {
  colorMode(HSB,255);
  size(300,300);
  frameRate(30);
  x = new float[arraySize];
  y = new float[arraySize];
  for(int i = 0; i < arraySize; i++) {
    x[i] = width/2;
    y[i] = height/2;
  }
}

void draw() {
  background(0);
  strokeWeight(1);
  // move each element one space down
  for (int i = 0; i < arraySize-1; i++) {
    x[i] = x[i+1];
    y[i] = y[i+1];
  }
  // put a random point in
  x[arraySize-1] = constrain(x[arraySize-2] + random(-1*speed,speed),0,width);
  y[arraySize-1] = constrain(y[arraySize-2] + random(-1*speed,speed),0,height);
  // draw a line between all points
  for(int i = 0; i < arraySize-1; i++) {
    stroke((millis()/100)%255,255,255,map(i,0,arraySize-1,0,255));
    line(x[i],y[i],x[i+1],y[i+1]);
    //point(x[i],y[i]);
  }
}
