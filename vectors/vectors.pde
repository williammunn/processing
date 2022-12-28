int numCircles = 100;
int arraySize = 30000;
Circle[] circles = new Circle[numCircles];
int countRemaining = numCircles;
int numRemainingArray[] = new int[arraySize];
int m;

void setup() {
  background(50);
  size(300,300);
  noStroke();
  for (int i = 0; i < numCircles; i ++) {
    circles[i] = new Circle();
  }
  for (int i = 0; i < arraySize; i ++) {
    numRemainingArray[i] = -1;
  }
}

class Circle {
  
  PVector location;
  PVector velocity;
  int diameter;
  float probHasCollided;
  boolean hasCollided;
  color colorNotCollided;
  color colorHasCollided;
  
  Circle() {
    location = new PVector(random(width/10,9*width/10),random(height/10,9*height/10));
    velocity = new PVector(random(-1,1),random(-1,1));
    diameter = 4;
    probHasCollided = 0.05;
    if (random(1) < probHasCollided) {
    hasCollided = true;
    } else {
      hasCollided = false;
    }
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
  
  void circleCollision(PVector otherCircleLocation, boolean otherCircleHasCollided) {
    if(location.dist(otherCircleLocation) < diameter) {
      if ((hasCollided == true || otherCircleHasCollided == true) && ((hasCollided == false || otherCircleHasCollided == false))) {
        hasCollided = true;
        countRemaining -= 1;
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
  noStroke();
  countRemaining = 0;
  fill(25,100);
  rect(0,0,width,height);
  // draw movers
  for (int i = 0; i < numCircles; i++) {
    circles[i].wallCollision();
    if (circles[i].hasCollided == false) {
      countRemaining += 1;
    }
    // check if this circle has collided with any other
    for (int j = 0; j < numCircles; j++) {
      if(i != j) {
        circles[i].circleCollision(circles[j].location,circles[j].hasCollided);
      }
    }
  circles[i].update();
  circles[i].display();
  }
  // write number remanining to array
  m = millis();
  if(m < arraySize) {
    numRemainingArray[m] = countRemaining;
  }
  // show number of green circles 
  text(countRemaining,width-30,height-30);
}
