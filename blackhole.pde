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

Boolean polygonIntersection(Debris d1, Debris d2) {
  for (int i = 0; i < d1.verts.length; i++) {
    PVector p1;
    PVector p2;
    if (i == d1.verts.length-1) {
      p1 = PVector.add(d1.verts[d1.verts.length-1], d1.pos);
      p2 = PVector.add(d1.verts[0], d1.pos);
    }
    else {
      p1 = PVector.add(d1.verts[i], d1.pos);
      p2 = PVector.add(d1.verts[i+1], d1.pos);
    }
    for (int j = 0; j < d2.verts.length; j++) {
      PVector q1;
      PVector q2;
      if (j == d2.verts.length-1) {
        q1 = PVector.add(d2.verts[d2.verts.length-1], d2.pos);
        q2 = PVector.add(d2.verts[0], d2.pos);
      }
      else {
        q1 = PVector.add(d2.verts[j], d2.pos);
        q2 = PVector.add(d2.verts[j+1], d2.pos);
      }
      if (linesIntersect(p1, p2, q1, q2) == true) {
        return true;
      }
    }
  }
  return false;
}

Boolean IsPolyOnScreen(Debris d1){
  for (int i = 0; i < d1.verts.length; i++) {
    PVector p1;
    PVector p2;
    PVector b1 = new PVector(0, 600);
    PVector b2 = new PVector(700, 600);
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
  Debris[] theD = new Debris[d.size()];
  theD = d.toArray(theD);
  if (theD.length >=2) {
    for (int i = 0; i < theD.length; i++) {
      for (int j = 0; j < theD.length; j++) {
            if (polygonIntersection(theD[i],theD[j]) == true){
              float newVely = min(theD[i].vel.y, theD[j].vel.y);
              theD[i].vel.y = newVely;
              theD[j].vel.y = newVely;
            }
        }
      }
    }
  }
  
void checkOffScreen(){
  Debris[] theD = new Debris[d.size()];
  theD = d.toArray(theD);
  for (int i = 0; i < theD.length; i++) {
    if (IsPolyOnScreen(theD[i]) == true){
      d1.vel.y = 0;
    } 
  }
}
  // if (bpos.y >= height-bs/2){
  //   bpos.y = height-bs/2;
  //   bvel.y = 0;
  // }

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

