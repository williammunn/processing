Ball[] balls = new Ball[5];

void setup() {
  size(300,300);
  noStroke();
  for (int i = 0; i < 5; i++) {
    balls[i] = new Ball(color(0),20,0.8,random(width/5,4*width/5),random(height/5,4*height/5));
  }
}

void draw() {
  fill(200,255);
  rect(0,0,width,height);
  //background(200);
  for(int i = 0; i < 5; i++) {
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
