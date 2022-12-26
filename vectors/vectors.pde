Circle[] circles = new Circle[25];

class Circle {
  float x, y;
  float xspeed, yspeed;
  int r, g, b, a;
  Circle(float x, float y, float xspeed, float yspeed, int r, int g, int b, int a) {
    this.x = x;
    this.y = y;
    this.xspeed = xspeed;
    this.yspeed = yspeed;
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  void checkCollision() {
   if ((x + 10) > width || (x - 10) < 0) {
    xspeed *= -1;
    }
    if ((y + 10) > height || (y - 10) < 0) {
      yspeed *= -1;
    }
    x += xspeed;
    y += yspeed;
  }
  void drawCircle() {
      fill(r,g,b,a);
      ellipse(x,y,20,20);
  } 
}

void setup() {
  background(0);
  size(300,300);
  noStroke();
  for (int i = 0; i < circles.length; i ++) {
    circles[i] = new Circle(random(width/3,2*width/3),random(height/3,2*height/3),random(-2,2),random(-2,2),round(random(255)),round(random(255)),round(random(255)),1);
  }
}

void draw() {
  for (int i = 0; i < circles.length; i++) {
    circles[i].checkCollision();
    circles[i].drawCircle();
  }
}
