int population = 20;
ArrayList<person> people = new ArrayList<person>();
int personSizeParameter = 10;
IntDict resultsDict;
Table resultsTbl;
TableRow resultsRow;

void setup() {
  size(600, 600);
  noStroke();
  ellipseMode(RADIUS);
  // prepare the table that will store the results
  resultsTbl = new Table();
  resultsTbl.addColumn("t");
  resultsTbl.addColumn("s");
  resultsTbl.addColumn("i");
  resultsTbl.addColumn("r");
  resultsDict = new IntDict;
  resultsDict.set("s",0);
  resultsDict.set("i",0);
  resultsDict.set("r",0);
  // the first time we create the population we don't know the arrayList size in advance
  for (int i = 0; i < population; i++) {
    people.add(new person('S',personSizeParameter,random(width),random(height)));
    resultsDict.increment("s");
  }
  // introduce a single infected person in addition, the Original (O) case
  people.add(new person('O',personSizeParameter,random(width),random(height)));
  resultsDict.add("i",1);
  // now we do, and can refer to its length using the size() method
  for (int i = 0; i < people.size(); i++) {
    if (people.get(i).hasCollidedWithWall()) {
      // need to subtract 1 off the increment value before losing this object
      resultsDict.sub("s",1);
      people.remove(i);
    }
  }
  // we also want to ensure that the initial locations are such that people are not in contact
  for (int i = 0; i < people.size(); i++) {
    for (int j = 0; j < people.size(); j++) {
      if (i != j) {
        if (people.get(i).hasCollidedWithPerson(people.get(j))) {
          if (people.get(i).personState == 'S') { // we need to keep the single initial infectious case
            resultsDict.sub("s",1);
          } else {
            people.remove(j);
          }
          resultsDict.sub("s",1);
        }
      }
    }
  }
}

void draw() {
  background(0);
  for (int i = 0; i < people.size(); i++) {
    person thisPerson = people.get(i);
    thisPerson.wallCollision();
    thisPerson.move();
    thisPerson.display();
    // perform the collisions with other people
    for (int j = 0; j < people.size(); j++) {
      if (i != j) {
        person otherPerson = people.get(j);
        thisPerson.collision(otherPerson);
      }
    }
    // deal with the possibility of recovering from the disease
    thisPerson.recovery();
  }
  // for each second that elapses, take a snapshot of the results and store this as a row of the table
  if (frameCount %% frameRate == 0) {
    resultsRow = resultsTbl.addRow();
    newRow.setInt("t",frameCount/frameRate);
    newRow.setInt("s",resultsDict.get("s"));
    newRow.setInt("i",resultsDict.get("s"));
    newRow.setInt("r",resultsDict.get("s"));
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == 49) {
      saveTable(resultsTbl, "data/results.csv");
    }
  }
}

class person {
  // properties
  char personState; // S = susceptible, I = infected, R = recovered
  float personSize;
  float personX;
  float personY;
  PVector personLocation;
  PVector personVelocity;
  color personColor;
  // person constructor function
  person(char _personState, float _personSize, float _personX, float _personY) {
    personState = _personState;
    personSize = _personSize;
    personX = _personX;
    personY = _personY;
    // vectors
    personLocation = new PVector(personX,personY);
    personVelocity = new PVector(random(-1,1), random(-1,1));
    personVelocity.normalize();
    personVelocity.mult(1); // gives us the optional ability to speed up movement
  }
  
  boolean hasCollidedWithPerson(person otherPerson) {
    
    // Get distances between the balls components
    PVector distanceVect = PVector.sub(otherPerson.personLocation, personLocation);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = personSize + otherPerson.personSize;

    if (distanceVectMag < minDistance) {
      return true;
    } else {
      return false;
    }
  }
  
  void recovery() {
    // set the "gamma" parameter
    float gamma = 0.0005;
    float randomNumber = random(1);
    boolean recover = (randomNumber < gamma);
    if (recover && personState == 'I') {
      personState = 'R';
      resultsDict.sub("i",1);
      resultsDict.add("r",1);
    }
  }
  
  void transmission(person otherPerson) {
    // set the "beta" parameter
    float beta = 0.4;
    float randomNumber = random(1);
    boolean infect = (randomNumber < beta);
    // main person gets infected
    if (infect && personState == 'S' && (otherPerson.personState == 'I' || otherPerson.personState == 'O')) {
      personState = 'I';
      resultsDict.sub("s",1);
      resultsDict.add("i",1);
    } else if (infect && (personState == 'I' || personState == 'O') && otherPerson.personState == 'S') {
      otherPerson.personState = 'I';
      resultsDict.sub("s",1);
      resultsDict.add("i",1);
    }
  }
  
  void collision(person otherPerson) {

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(otherPerson.personLocation, personLocation);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = personSize + otherPerson.personSize;
  
    // logic for dealing with collisions between people
    if (distanceVectMag < minDistance) {
      // pass on the disease
      transmission(otherPerson);
      
      // remaining calcs
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      otherPerson.personLocation.add(correctionVector);
      personLocation.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * personVelocity.x + sine * personVelocity.y;
      vTemp[0].y  = cosine * personVelocity.y - sine * personVelocity.x;
      vTemp[1].x  = cosine * otherPerson.personVelocity.x + sine * otherPerson.personVelocity.y;
      vTemp[1].y  = cosine * otherPerson.personVelocity.y - sine * otherPerson.personVelocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((personSize - otherPerson.personSize) * vTemp[0].x + 2 * otherPerson.personSize * vTemp[1].x) / (personSize + otherPerson.personSize);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((otherPerson.personSize - personSize) * vTemp[1].x + 2 * personSize * vTemp[0].x) / (personSize + otherPerson.personSize);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      otherPerson.personLocation.x = personLocation.x + bFinal[1].x;
      otherPerson.personLocation.y = personLocation.y + bFinal[1].y;

      personLocation.add(bFinal[0]);

      // update velocities
      personVelocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      personVelocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      otherPerson.personVelocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      otherPerson.personVelocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }
  
  boolean hasCollidedWithWall() {
    
    if (personLocation.x - personSize < 0) {
      return true;
    } else if (personLocation.x + personSize > width) {
      return true;
    } else if (personLocation.y - personSize < 0) {
      return true;
    } else if (personLocation.y + personSize > height) {
      return true;
    } else {
      return false;
    }
  }
  
  void wallCollision() {
    
    if (hasCollidedWithWall()) {
      if (personLocation.x - personSize < 0) {
        personVelocity.x = personVelocity.x * -1;
        personLocation.x = personSize;
      } else if (personLocation.x + personSize > width) {     
        personVelocity.x = personVelocity.x * -1;
        personLocation.x = width - personSize;
      } else if (personLocation.y - personSize < 0) {     
        personVelocity.y = personVelocity.y * -1;
        personLocation.y = personSize;
      } else if (personLocation.y + personSize > height) {     
        personVelocity.y = personVelocity.y * -1;
        personLocation.y = height - personSize;
      }
    }
  }
  
  void move() {
    // update
    personLocation.add(personVelocity);
  }

  void display() {
    if (personState == 'S') {
      personColor = color(0,0,255); // blue
    } else if (personState == 'I') {
      personColor = color(255,0,0); // red
    } else if (personState == 'O') {
      personColor = color(255,0,0); // red
    } else if (personState == 'R') {
      personColor = color(0,255,0); // green
    }
    fill(personColor);
    ellipse(personLocation.x, personLocation.y, personSize, personSize);
  }
}
