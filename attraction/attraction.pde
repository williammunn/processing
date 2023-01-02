Ball ball;

void setup() {
  size(300, 300);
  ball = new Ball(20, width/2, height/2);
}

void draw() {
  background(0);
  ball.move();
  ball.display();
}

void keyPressed() {
  if (key == ' ') {
    ball.ballLocation.x = width/2;
    ball.ballLocation.y = height/2;
    ball.ballVelocity.x = 0;
    ball.ballVelocity.y = 0;
  }
}

class Ball {
  // ball properties
  float ballDiameter;
  float ballX;
  float ballY;
  PVector ballLocation;
  PVector ballVelocity;
  PVector ballAcceleration;
  PVector mouseVector;
  float scale;
  // ball constructor function
  Ball(float _ballDiameter, float _ballX, float _ballY) {
    ballDiameter = _ballDiameter;
    ballX = _ballX;
    ballY = _ballY;
    // vectors
    ballLocation = new PVector(ballX, ballY);
    ballVelocity = new PVector(0, 0);
    ballAcceleration = new PVector(0, 0);
  }

  void move() {
    // define a vector from the ball and towards the mouse
    mouseVector = new PVector(mouseX, mouseY);
    ballAcceleration = mouseVector.sub(ballLocation);
    ballAcceleration.normalize();
    scale = mouseVector.dist(ballLocation)/2000;
    ballAcceleration.mult(scale);

    // update
    ballVelocity.add(ballAcceleration);
    ballLocation.add(ballVelocity);
  }

  void display() {
    fill(255);
    ellipse(ballLocation.x, ballLocation.y, ballDiameter, ballDiameter);
  }
}
