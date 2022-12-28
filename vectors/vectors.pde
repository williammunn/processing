int numCircles = 50;
Circle[] circles = new Circle[numCircles];
int countCollisions = 0;

void setup() {
  background(50);
  size(300,300);
  noStroke();
  for (int i = 0; i < numCircles; i ++) {
    circles[i] = new Circle(); // fill colour
  }
}

class Circle {
  
  PVector location;
  PVector velocity;
  int diameter;
  boolean hasCollided;
  color colorNotCollided;
  color colorHasCollided;
  
  Circle() {
    location = new PVector(random(width/10,9*width/10),random(height/10,9*height/10));
    velocity = new PVector(random(-1,1),random(-1,1));
    diameter = 10;
    hasCollided = false;
    colorNotCollided = color(100,200,100);
    colorHasCollided = color(200,100,100);
  }
  
  void wallCollision() {
    if ((location.x + 0.5*diameter) > width || (location.x - 0.5*diameter) < 0) {
    velocity.x *= -1;
    }
    if ((location.y + 0.5*diameter) > height || (location.y - 0.5*diameter) < 0) {
      velocity.y *= -1;
    }
  }
  
  void circleCollision(PVector otherCircleLocation) {
    if(location.dist(otherCircleLocation) < diameter) {
      if (hasCollided == false) {
        hasCollided = true;
        countCollisions += 1;
      }
    }
  }
      
  
  void update() {
    location.add(velocity);
  }
    
  
  void display() {
      if(hasCollided == true) {
        fill(colorHasCollided);
      } else {
        fill(colorNotCollided);
      }
      ellipse(location.x,location.y,diameter,diameter);
  }
}

void draw() {
  fill(50,100);
  rect(0,0,width,height);
  // draw movers
  for (int i = 0; i < numCircles; i++) {
    circles[i].wallCollision();
    // check if this circle has collided with any other
    for (int j = 0; j < numCircles; j++) {
      if(i != j) {
        circles[i].circleCollision(circles[j].location);
      }
    }
  circles[i].update();
  circles[i].display();
  }
  text(numCircles - countCollisions,width-30,height-30);
}
