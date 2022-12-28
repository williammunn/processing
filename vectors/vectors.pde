int numCircles = 10;
Circle[] circles = new Circle[numCircles];

class Circle {
  
  PVector location;
  PVector velocity;
  int diameter;
  boolean hasCollided = false;
  
  Circle() {
    location = new PVector(random(width/3,2*width/3),random(height/3,2*height/3));
    velocity = new PVector(random(-1,1),random(-1,1));
    diameter = 20;
  }
  
  void wallCollision() {
    if ((location.x + 0.5*diameter) > width || (location.x - 0.5*diameter) < 0) {
    velocity.x *= -1;
    }
    if ((location.y + 0.5*diameter) > height || (location.y - 0.5*diameter) < 0) {
      velocity.y *= -1;
    }
  }
  
  void update() {
    location.add(velocity);
  }
    
  
  void display() {
      fill(200);
      ellipse(location.x,location.y,diameter,diameter);
  } 
  
}

void setup() {
  background(50);
  size(300,300);
  noStroke();
  for (int i = 0; i < circles.length; i ++) {
    circles[i] = new Circle(); // fill colour
  }
}

void draw() {
  fill(50,100); // semi transparent
  rect(0,0,width,height);
  // draw movers
  for (int i = 0; i < circles.length; i++) {
    circles[i].wallCollision();
    circles[i].update();
    circles[i].display();
  }
}
