int numBalls = 100;
Ball[] balls = new Ball[numBalls];

void setup() {
  size(300,300);
  noStroke();
  colorMode(HSB,400);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(color(random(400),400,400,200),20,0.8,random(width/10,9*width/10),random(height/10,9*height/10));
  }
}

void draw() {
  background(0,0,400);
  for(int i = 0; i < numBalls; i++) {
    balls[i].applyGravity();
    balls[i].collide();
    balls[i].move();
    balls[i].display();
  }
}

class Ball {
  // ball properties
  color ballColor;
  float ballDiameter;
  float ballElasticity;
  float ballX;
  float ballY;
  float gravity = 0.2;
  float xfriction = 1;
  float yfriction = 1.5;
  // vectors for ball
  PVector ballLocation;
  PVector ballVelocity;
  PVector ballAcceleration;
  // ball constructor function
  Ball(color _ballColor, float _ballDiameter, float _ballElasticity, float _ballX, float _ballY) {
    ballColor = _ballColor;
    ballDiameter = _ballDiameter;
    ballElasticity = _ballElasticity;
    ballX = _ballX;
    ballY = _ballY;
    // vectors
    ballLocation = new PVector(ballX,ballY);
    ballVelocity = new PVector(random(-2,2),0);
    ballAcceleration = new PVector(0,0);
  }
  
  void collide() {
    if ((ballLocation.x > width - ballDiameter/2) && ballVelocity.x > 0) {
      if(abs(ballVelocity.x) > xfriction) {
        ballVelocity.x *= -1*ballElasticity;
      } else {
        ballVelocity.x = 0;
      }
    }
    if (ballLocation.x < ballDiameter/2 && ballVelocity.x < 0) {
      if (abs(ballVelocity.x) > xfriction) {
        ballVelocity.x *= -1*ballElasticity;
      } else {
        ballVelocity.x = 0;
      }
    }
    // to bounce, needs a minimum velocity
    if (ballLocation.y > height - ballDiameter/2 && ballVelocity.y > 0) {
      if (abs(ballVelocity.y) > yfriction) {
        ballVelocity.y *= -1*ballElasticity;
      } else {
        ballVelocity.y = 0;
      }
    }
  }
  
  void applyGravity() {
    ballVelocity.y += gravity;
  }
  
  void move() {
    ballVelocity.add(ballAcceleration);
    ballLocation.add(ballVelocity);
  }
  
  void display() {
    fill(ballColor);
    ellipse(ballLocation.x,ballLocation.y,ballDiameter,ballDiameter);
  }
}
