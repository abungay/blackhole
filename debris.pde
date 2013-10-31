class Debris {
  PVector[] verts;
  PVector pos;
  PVector vel;
  int R;
  int G;
  int B;
  
  Debris(PVector pos) {
    //used for the man class
    this.pos = pos;
  }
  
  Debris(PVector pos, int nVerts){
    //constructor for creating debris/asteroids
    this(pos);
    this.vel = new PVector(0, (random(1)-0.5)+1.5);
    this.verts =  new PVector[nVerts];
    this.R = int(190 + (random(40)-20));
    this.G = int(170 + (random(40)-20));
    this.B = int(80 + (random(40)-20));
    //make the points be drawn evenly spaced out with the position of the asteroid at the center
    float angle = TWO_PI/nVerts;
    for(int f = 0; f < nVerts; f++){
      float myangle = f*angle;
      float dist = (random(40) - 20) + 70;
      this.verts[f] = new PVector();
      this.verts[f].x = dist*cos(myangle);
      this.verts[f].y = dist*sin(myangle);
    }
  }
  
  void update() {
    pos.add(vel);
  }
  
  void draw() {
    //translate the points to the position of the debris
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    beginShape();
    for (int j = 0; j < verts.length; j++){
      vertex(verts[j].x, verts[j].y);
    }
    endShape(CLOSE);
    popMatrix();
  }
}

Boolean linesIntersect(PVector p1, PVector p2, PVector q1, PVector q2) {
  //point slope line formula, also tests for vertical lines and exceptions (checks to see if two lines are colliding with eachother)
  float mp = (p2.y-p1.y)/(p2.x-p1.x);
  float mq = (q2.y-q1.y)/(q2.x-q1.x);
  if (mp == mq) return false;
  float bp = p1.y - mp*p1.x;
  float bq = q1.y - mq*q1.x;
  float x, y;
  if (p2.x - p1.x == 0) {
    x = p1.x;
    y = mq*x + bq;
  } else if (q2.x - q1.x == 0) {
    x = q1.x;
    y = mp*x + bp;
  } else {
    x = (bq - bp) / (mp - mq);
    y = mp*x + bp;
  }
  boolean onP = x >= min(p1.x, p2.x) && x <= max(p1.x, p2.x)
             && y >= min(p1.y, p2.y) && y <= max(p1.y, p2.y);
  boolean onQ = x >= min(q1.x, q2.x) && x <= max(q1.x, q2.x)
             && y >= min(q1.y, q2.y) && y <= max(q1.y, q2.y);
  return onP && onQ;
}
