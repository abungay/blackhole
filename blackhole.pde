int frame = 0;
ArrayList<Debris> d;
Man m;
PVector bpos, bvel, accel;
final int bs = 30;

void setup() {
  size(700, 600);
  //bpos = new PVector(350,585);
  //bvel = new PVector(0,0);
  accel = new PVector(0, 0.1633);
  d = new ArrayList<Debris>();
  m = new Man(new PVector(350, 530));
}

void draw() {
  frame++;
  //bvel.add(accel);
  //bpos.add(bvel);
  //m.vel.add(accel);
  m.pos.add(m.vel);
  //  if (bvel.x > 0){
  //    accel.x = -0.1;
  //  }else if(bvel.x < 0){
  //    accel.x = 0.1;
  //  }
  background(200);
  //translate(0,500-bpos.y);
  fill(191, 169, 82);
  updateAll();
  generateDebris();
  fill(255, 0, 0);
  //ellipse(bpos.x,bpos.y,bs,bs);
  fill(0);
  text("Use arrow keys to move ball, ball vs poly collision not implemented yet.", 150, 100);
  line(0, 601, 700, 601);
  checkForCollisions();
}

Boolean polyonIntersection(Debris d1, Debris d2) {
  for (int p = 0; p < theD[i].verts.length; p++) {
    PVector p1;
    PVector p2;
    if (p == theD[i].verts.length-1) {
      p1 = PVector.add(theD[i].verts[theD[i].verts.length-1], theD[i].pos);
      p2 = PVector.add(theD[i].verts[0], theD[i].pos);
    }
    else {
      p1 = PVector.add(theD[i].verts[p], theD[i].pos);
      p2 = PVector.add(theD[i].verts[p+1], theD[i].pos);
    }
    for (int e = 0; e < theD[u].verts.length; e++) {
      PVector q1;
      PVector q2;
      PVector b1 = new PVector(0, 600);
      PVector b2 = new PVector(700, 600);
      if (e == theD[u].verts.length-1) {
        q1 = PVector.add(theD[u].verts[theD[u].verts.length-1], theD[u].pos);
        q2 = PVector.add(theD[u].verts[0], theD[u].pos);
      }
      else {
        q1 = PVector.add(theD[u].verts[e], theD[u].pos);
        q2 = PVector.add(theD[u].verts[e+1], theD[u].pos);
      }
      if (linesIntersect(p1, p2, q1, q2) == true) {
        float newVely = min(theD[i].vel.y, theD[u].vel.y);
        theD[i].vel.y = newVely;
        theD[u].vel.y = newVely;
      }
      if (linesIntersect(p1, p2, b1, b2) == true) {
        theD[i].vel.y = 0;
      }
    }
  }
}

void checkForCollisions() {
  Debris[] theD = new Debris[d.size()];
  theD = d.toArray(theD);
  if (theD.length >=2) {
    for (int i = 0; i < theD.length; i++) {
      for (int u = 0; u < theD.length; u++) {
        for (int p = 0; p < theD[i].verts.length; p++) {
          PVector p1;
          PVector p2;
          if (p == theD[i].verts.length-1) {
            p1 = PVector.add(theD[i].verts[theD[i].verts.length-1], theD[i].pos);
            p2 = PVector.add(theD[i].verts[0], theD[i].pos);
          }
          else {
            p1 = PVector.add(theD[i].verts[p], theD[i].pos);
            p2 = PVector.add(theD[i].verts[p+1], theD[i].pos);
          }
          for (int e = 0; e < theD[u].verts.length; e++) {
            PVector q1;
            PVector q2;
            PVector b1 = new PVector(0, 600);
            PVector b2 = new PVector(700, 600);
            if (e == theD[u].verts.length-1) {
              q1 = PVector.add(theD[u].verts[theD[u].verts.length-1], theD[u].pos);
              q2 = PVector.add(theD[u].verts[0], theD[u].pos);
            }
            else {
              q1 = PVector.add(theD[u].verts[e], theD[u].pos);
              q2 = PVector.add(theD[u].verts[e+1], theD[u].pos);
            }
            if (linesIntersect(p1, p2, q1, q2) == true) {
              float newVely = min(theD[i].vel.y, theD[u].vel.y);
              theD[i].vel.y = newVely;
              theD[u].vel.y = newVely;
            }
            if (linesIntersect(p1, p2, b1, b2) == true) {
              theD[i].vel.y = 0;
            }
          }
        }
      }
    }
  }
  // if (bpos.y >= height-bs/2){
  //   bpos.y = height-bs/2;
  //   bvel.y = 0;
  // }
}

void generateDebris() {
  if (frame % 180 == 0 && d.size() < 20) {
    PVector dpos = new PVector();
    dpos.x = random(width);
    dpos.y = -120;
    int mverts = int(random(5)+5);
    d.add(new Debris(dpos, mverts));
  }
}

void updateAll() {
  m.update();
  m.draw();
  if (d.size() > 0) {
    for (Debris theD : d) {
      theD.update();
      theD.draw();
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      m.vel.x = 3;
    }
    else if (keyCode == LEFT) {
      m.vel.x = -3;
    }
    if (keyCode == UP) {
      if (m.vel.y == 0) {
        m.vel.y = -5;
      }
    }
  }
}

