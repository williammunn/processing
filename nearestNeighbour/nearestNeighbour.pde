int numBalls = 50;
Ball[] balls = new Ball[numBalls];
float minDist;
int minIndex;
float minX, minY;

void setup() {
  size(300,300);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(color(255,234,147),5);
  }
}

void draw() {
  fill(78,95,157,50);
  rect(-20,-20,width+40,height+40);
  for (int i = 0; i < numBalls; i++) {
    balls[i].collide();
    balls[i].move();
    balls[i].display();
    minDist = 10000; // large number
    minIndex = 10000; // large number
    for (int j = 0; j < numBalls; j++) {
      if (i != j) {
        if (balls[i].ballLocation.dist(balls[j].ballLocation) < minDist) {
          minIndex = j;
          minDist = balls[i].ballLocation.dist(balls[j].ballLocation);
          minX = balls[j].ballLocation.x;
          minY = balls[j].ballLocation.y;
        }
      }
    }
    // draw line between each ball and its nearest neighbour
    stroke(255,234,147);
    strokeWeight(min(10/minDist,5));
    line(balls[i].ballLocation.x,balls[i].ballLocation.y,minX,minY);
  }
}


class Ball {
  // ball properties
  color ballColor;
  float ballDiameter;
  // vectors for ball
  PVector ballLocation;
  PVector ballVelocity;
  // ball constructor function
  Ball(color _ballColor, float _ballDiameter) {
    ballColor = _ballColor;
    ballDiameter = _ballDiameter;
    // vectors
    ballLocation = new PVector(random(width/10,9*width/10),random(height/10,9*height/10));
    ballVelocity = new PVector(random(-0.5,0.5),random(-0.5,0.5));
  }
  
  void collide() {
    if (ballLocation.x > width - ballDiameter/2 || ballLocation.x < ballDiameter/2) {
      ballVelocity.x *= -1;
    }
    if (ballLocation.y > height - ballDiameter/2 || ballLocation.y < ballDiameter/2) {
      ballVelocity.y *= -1;
    }
  }
  
  void move() {
    ballLocation.add(ballVelocity);
  }
  
  void display() {
    fill(ballColor);
    ellipse(ballLocation.x,ballLocation.y,ballDiameter,ballDiameter);
  }

}
