int arraySize = 100;
float[] x;
float[] y;

void setup() {
  size(150,150);
  x = new float[arraySize];
  y = new float[arraySize];
  for(int i = 0; i < arraySize; i++) {
    x[i] = width/2;
    y[i] = height/2;
  }
}

void draw() {
  fill(50,5); // semi transparent
  rect(0,0,width,height);
  stroke(200);
  // move each element one space down
  for (int i = 0; i < arraySize-1; i++) {
    x[i] = x[i+1];
    y[i] = y[i+1];
  }
  // put a random point in
  x[arraySize-1] = constrain(x[arraySize-2] + random(-2,2),0,width);
  y[arraySize-1] = constrain(y[arraySize-2] + random(-2,2),0,height);
  // draw a line between all points
  for(int i = 0; i < arraySize-1; i++) {
    line(x[i],y[i],x[i+1],y[i+1]);
  }
}
