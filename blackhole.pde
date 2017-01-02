import java.util.Iterator;

int frame = 0; //used for keeping track of current frame
ArrayList<Debris> d; //list of all debris/asteroids that are on the screen
PVector accel; //acceleration of the man
Boolean movinghoriz = false; //used for checking to see if man is being controlled by arrowkeys
Boolean maninair = true; //check to see if man is on the ground, letting him jump from up arrowkey
Boolean manonground = false; //used for telling manonair if the man is on the ground
Boolean manonpoly = false; //used for telling manonair if the man is on a poly
Boolean dead = false; //true while the man dies, displays YOU DIED text for 5 seconds
int deadmillis = 0; //time when the man died at
String deadtext = ""; //the cause text to be displayed when the man dies
float blackholesize = 5; //the size of the blackhole that starts at 5 and gets larger over time
ArrayList<Debris> mcols; //arraylist of debris/asteroids that the man is currently colliding with
Man man; //man object

void setup() {
  size(700, 600);
  accel = new PVector(0, 0.1633); //initiating the man's acceleration
  d = new ArrayList<Debris>(); //initiating the arraylist of debris/asteroids
  mcols = new ArrayList<Debris>(); //initiating the arraylist that keeps track of debris/asteroids that the man is currently colliding with
  man = new Man(new PVector(350, 530)); //initiating the man object and spawning him at the coords(350,530)
}

void draw() {
  if (!dead) {
    frame++; //count the current frame
    blackholesize += 0.35; //increase black hole size over time
    man.vel.add(accel); 
    man.pos.add(man.vel); 
    if (!movinghoriz) {
      //slow down the ball if not being controlled by the arrow keys
      if (man.vel.x > 0.01) {
        accel.x = -0.1;
      }
      else if (man.vel.x < -0.01) {
        accel.x = 0.1;
      }
      else if (man.vel.x >= -0.01 && man.vel.x <= 0.01) {
        accel.x = 0;
        man.vel.x = 0;
      }
    }
    else {
      //if being controlled by arrow keys make the man's acceleration 0
      accel.x = 0;
    }
    background(200);
    translate(0, 400-man.pos.y); //make screen follow man, panning up and down depending on his y position
    updateAll(); //makes man and all debris/asteroids' positions be controlled by their velocities, and draw them on screen
    generateDebris(); //create new debris near the top of the screen every couple seconds
    fill(100, 100, 100);
    rect(0, 601, 700, 601); // draw the 'ground'
    fill(0);
    ellipse(350, 800, blackholesize, blackholesize); //draw the 'blackhole'
    textSize(30);
    text("Height: " + int(-(man.pos.y-558)/20) + "ft", 500, man.pos.y-350); //display height of man
    checkForCollisions(); //check to see if man is colliding with debris/asteroids
    checkOffScreen(); //check if man or debris/asteroids are off the screen
    checkBlackHole(); //see if the blackhole is touching the man or the asteroids
  }
  else {
    //if MAN IS DEAD the below code is run
    fill(255, 50, 50);
    textSize(50);
    text("YOU DIED!", 200, 300);
    textSize(30);
    text(deadtext, 200, 400);
    if (millis() - deadmillis > 5000) {
      //restarts the game and removes death text after 5 seconds (5000 milli seconds)
      dead = false;
      maninair = true;
      frame = 0;
      d = new ArrayList<Debris>();
      mcols = new ArrayList<Debris>();
      man = new Man(new PVector(350, 530));
      blackholesize = 5;
    }
  }
}

Boolean polygonIntersection(Debris d1, Debris d2) {
  //checks two different polygons with eachother to see if they are intersecting with eachother
  for (int i = 0; i < d1.verts.length; i++) {
    PVector p1; //first point of first line
    PVector p2; //second point of first line
    if (i == d1.verts.length-1) {
      p1 = PVector.add(d1.verts[d1.verts.length-1], d1.pos);
      p2 = PVector.add(d1.verts[0], d1.pos);
    }
    else {
      p1 = PVector.add(d1.verts[i], d1.pos);
      p2 = PVector.add(d1.verts[i+1], d1.pos);
    }
    for (int j = 0; j < d2.verts.length; j++) {
      PVector q1; //first point of second line
      PVector q2; //second point of second line
      if (j == d2.verts.length-1) {
        q1 = PVector.add(d2.verts[d2.verts.length-1], d2.pos);
        q2 = PVector.add(d2.verts[0], d2.pos);
      }
      else {
        q1 = PVector.add(d2.verts[j], d2.pos);
        q2 = PVector.add(d2.verts[j+1], d2.pos);
      }
      //using line intersection function located in the debris tab
      if (linesIntersect(p1, p2, q1, q2) == true) {
        return true;
      }
    }
  }
  return false;
}

Boolean IsPolyOffScreen(Debris d1) {
  //checks to see if a polygon is at the bottom of the screen
  for (int i = 0; i < d1.verts.length; i++) {
    PVector p1;
    PVector p2;
    PVector b1 = new PVector(0, 600); //first point of invisible line at bottom of screen
    PVector b2 = new PVector(700, 600); //second point of invisible line at bottom of screen
    if (i == d1.verts.length-1) {
      p1 = PVector.add(d1.verts[d1.verts.length-1], d1.pos);
      p2 = PVector.add(d1.verts[0], d1.pos);
    }
    else {
      p1 = PVector.add(d1.verts[i], d1.pos);
      p2 = PVector.add(d1.verts[i+1], d1.pos);
    }
    if (linesIntersect(p1, p2, b1, b2) == true) {
      return true;
    }
  }
  return false;
}

void checkForCollisions() {
  //Check to see if asteroid vs asteroids collide or asteroids vs man collide
  Debris[] theD = new Debris[d.size()];
  theD = d.toArray(theD);
  int crush = 0;
  if (theD.length >=2) {
    for (int i = 0; i < theD.length; i++) {
      //loop through all debris/asteroids
      if (polygonIntersection(theD[i], man)) {
        //check to see if man is intersecting with one of the asteroids/debris
        while (polygonIntersection (theD[i], man)) {
          //keep man from entering a debris/asteroid
          man.pos.x += ((man.pos.x-theD[i].pos.x)/(abs(man.pos.x-theD[i].pos.x)))*0.1;
          man.pos.y += ((man.pos.y-theD[i].pos.y)/(abs(man.pos.y-theD[i].pos.y)))*0.1;
          crush++; //keep track of how long it took to get man out of asteroid
        }
        maninair = false;
        mcols.add(theD[i]); //store what polygon the man is colliding with
        man.vel.y = 0;
        manonpoly = true;
      }
      else {
        //check to see if man is still colliding with any polygons
        if (mcols.contains(theD[i])) {
          mcols.remove(theD[i]);
        }
        if (mcols.size() == 0) {
          manonpoly = false;
        }
      }
      for (int j = 0; j < theD.length; j++) {
        //picks loops through all asteroids/debris on screen and checks to see if they are colliding with eachother
        if (polygonIntersection(theD[i], theD[j]) == true) {
          //if they are colliding then set their velocities to the minium of their two velocities
          float newVely = min(theD[i].vel.y, theD[j].vel.y);
          theD[i].vel.y = newVely;
          theD[j].vel.y = newVely;
        }
      }
    }
  }
  if (crush > 300 && (maninair == false)) {
    //checks to see how long it took to remove man from polygon if he collides with one, this should be greater than 300 only if the man
    //is trapped between two polygons, so when he is crushed by an asteroid. this means that the game will restart when this happens
    restartGame(0); //restart game and display crushed message
  }
}

void checkOffScreen() {
  //keep desbris/asteroids and man from falling off the screen
  Debris[] theD = new Debris[d.size()];
  theD = d.toArray(theD);
  if (man.pos.y > -200) {
    //only loop through all asteroids if man is still low enough to even see the bottom of the screen.
    for (int i = 0; i < theD.length; i++) {
      if (IsPolyOffScreen(theD[i]) == true) {
        theD[i].vel.y = 0;
      }
    }
  }
  //check the man's y position ( at the center of his body ) and add his lowest point to that and make sure its not under the 'ground'
  if (man.pos.y > 600 - 42.7) {
    man.pos.y = 600 - 42.7;
    manonground = true;
    man.vel.y = 0;
  }
  else {
    //let the man jump if he is not on the ground or on a poly
    manonground = false;
    if (manonpoly = false) {
      maninair = true;
    }
  }
  if (man.pos.x > 700 + 25.9 && man.vel.x > 0) {
    man.pos.x = -26.6;
  }
  if (man.pos.x < -26.6 && man.vel.x < 0) {
    man.pos.x = 700 + 25.9;
  }
}

void checkBlackHole() {
  //only safe way to remove debris/asteroids from the arraylist if they are touched by the blackhole
  Iterator<Debris> iter = d.iterator();
  while (iter.hasNext()) {
    PVector pos = iter.next().pos;
    if (dist(pos.x, pos.y, 350, 800) <= blackholesize/2-20) {
      iter.remove();
    }
  }
  //check to see if the man is in the blackhole
  if (dist(man.pos.x, man.pos.y, 350, 800) <= blackholesize/2) {
    restartGame(1);
  }
}

void generateDebris() {
  //create new debris over time
  if (frame % 180 == 0 && d.size() < 40) {
    PVector dpos = new PVector();
    dpos.x = random(width);
    dpos.y = man.pos.y-520;
    int mverts = int(random(5)+5);
    d.add(new Debris(dpos, mverts));
  }
}

void updateAll() {
  //update all velocities, positions, and draw all on screen
  fill(0, 0, 255);
  man.update();
  man.draw();
  if (d.size() > 0) {
    for (Debris theD : d) {
      fill(theD.R, theD.G, theD.B);
      theD.update();
      theD.draw();
    }
  }
}

void keyPressed() {
  //let man be moved by arrowkeys ( moving left, right, and jumping )
  if (key == CODED) {
    if (keyCode == RIGHT) {
      man.vel.x = 1.5;
      movinghoriz = true;
    }
    else if (keyCode == LEFT) {
      man.vel.x = -1.5;
      movinghoriz = true;
    }
    if (keyCode == UP) {
      if (maninair = false || man.vel.y == 0) {
        maninair = true;
        man.vel.y = -6;
      }
    }
  }
}

void keyReleased() {
  //make the man deaccelerate ( slowdown ) if he is not being controlled by the arrowkeys
  if (key == CODED) {
    if (keyCode == RIGHT) {
      movinghoriz = false;
    }
    else if (keyCode == LEFT) {
      movinghoriz = false;
    }
  }
}

void restartGame(int cause) {
  //display the death text for 5 seconds, then restart ( text displayed in void draw )
  switch(cause) {
  case 0:
    deadtext = "(Crushed by an asteroid)";
    break;
  case 1:
    deadtext = "(Sucked into the blackhole)";
    break;
  }
  dead = true;
  deadmillis = millis();
}

