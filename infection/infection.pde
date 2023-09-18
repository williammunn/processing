int population = 8;
ArrayList<person> people = new ArrayList<person>();

void setup() {
  size(300, 300);
  noStroke();
  // the first time we create the population we don't know the arrayList size in advance
  for (int i = 0; i < population; i++) {
    people.add(new person(random(10,50),random(width),random(height)));
  }
  // now we do, and can refer to its length using the size() method
  for (int i = 0; i < people.size(); i++) {
    if (people.get(i).checkWallCollision()) {
      people.remove(i);
    }
  }
}

void draw() {
  background(0);
  for (int i = 0; i < people.size(); i++) {
    fill(155);
    person thisPerson = people.get(i);
    thisPerson.wallCollision();
    thisPerson.move();
    for (int j = 0; j < people.size(); j++) {
      if (i != j) {
        person otherPerson = people.get(j);
        if (thisPerson.personIsInCloseContact(otherPerson)) {
          fill(255);
        }
      }
    }
    thisPerson.display();
  }
}

class person {
  // properties
  float personSize;
  float personX;
  float personY;
  PVector personLocation;
  PVector personVelocity;
  // ball constructor function
  person(float _personSize, float _personX, float _personY) {
    personSize = _personSize;
    personX = _personX;
    personY = _personY;
    // vectors
    personLocation = new PVector(personX,personY);
    personVelocity = new PVector(random(-1,1), random(-1,1));
    personVelocity.normalize();
    personVelocity.mult(2);
  }
  
  boolean personIsInCloseContact(person other) {
    if (this.personLocation.dist(other.personLocation) <= 0.5*(this.personSize + other.personSize)) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean checkWallCollision() {
    if (personLocation.x - personSize/2 < 0) {
      return true;
    } else if (personLocation.x + personSize/2 > width) {
      return true;
    } else if (personLocation.y - personSize/2 < 0) {
      return true;
    } else if (personLocation.y + personSize/2 > height) {
      return true;
    } else {
      return false;
    }
  }
  
  void wallCollision() {
    // run function once
    boolean collisionCheck = this.checkWallCollision();
    if (collisionCheck) {
      if (personLocation.x - personSize/2 < 0) {
        personVelocity.x = personVelocity.x * -1;
        personLocation.x = personSize/2;
      } else if (personLocation.x + personSize/2 > width) {     
        personVelocity.x = personVelocity.x * -1;
        personLocation.x = width - personSize/2;
      } else if (personLocation.y - personSize/2 < 0) {     
        personVelocity.y = personVelocity.y * -1;
        personLocation.y = personSize/2;
      } else if (personLocation.y + personSize/2 > height) {     
        personVelocity.y = personVelocity.y * -1;
        personLocation.y = height - personSize/2;
      }
    }
  }
    
  void move() {
    // update
    personLocation.add(personVelocity);
  }

  void display() {
    ellipse(personLocation.x, personLocation.y, personSize, personSize);
  }
}
