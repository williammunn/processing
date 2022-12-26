color randColor;
int h;
int s;
int b;

void setup() {
  size(300,300);
  noStroke();
  colorMode(HSB,400);
  h = 400;
  s = 400;
  b = 400;
}

void mousePressed() {
  // determine random colour
  h = round(random(400));
  s = round(random(400));
  b = round((400));
}
  

void draw() {
  // random background
  randColor = color(h,s,b);
  background(randColor);
}
