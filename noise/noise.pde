int arraySize = 200;
float[] x;
float[] y;

void setup() {
  size(240,240);
  frameRate(30);
  x = new float[arraySize];
  y = new float[arraySize];
  for(int i = 0; i < arraySize; i++) {
    x[i] = width/2;
    y[i] = height/2;
  }
}

void draw() {
  smooth();
  fill(200); // semi transparent
  rect(-10,-10,width+20,height+20);
  strokeWeight(1);
  // move each element one space down
  for (int i = 0; i < arraySize-1; i++) {
    x[i] = x[i+1];
    y[i] = y[i+1];
  }
  // put a random point in
  x[arraySize-1] = constrain(x[arraySize-2] + random(-5,5),0,width);
  y[arraySize-1] = constrain(y[arraySize-2] + random(-5,5),0,height);
  // draw a line between all points
  for(int i = 0; i < arraySize-1; i++) {
    stroke(map(i,0,arraySize-1,200,50));
    line(x[i],y[i],x[i+1],y[i+1]);
  }
}
