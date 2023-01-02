Ball ball;
float gravity;

void setup() {
  size(300,300);
  noStroke();
  Ball ball = new Ball(color(0),20,0.5,width/2,height/2);
}

void draw() {
  background(200);
  ball.applyGravity();
  ball.collide();
  ball.move();
  ball.display();
}

class Ball {
  // ball properties
  color ballColor;
  float ballDiameter;
  float ballElasticity;
  float ballX;
  float ballY;
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
    ballVelocity = new PVector(0,0);
    ballAcceleration = new PVector(0,0);
  }
  
  void collide() {
    if ((ballLocation.x > width - ballDiameter/2) || (ballLocation.x < width - ballDiameter/2)) {
      ballVelocity.x *= -1*ballElasticity;
    }
    if (ballLocation.y > height - ballDiameter/2) {
      ballVelocity.y *= -1*ballElasticity;
    }
  } 
  
  void applyGravity() {
    ballVelocity.y += -1*gravity;
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
  
