class Debris {
  PVector[] verts;
  PVector pos;
  PVector vel;
  PVector lowestpt;
  
  Debris(PVector pos, int nVerts){
    this.pos = pos;
    this.vel = new PVector(0, (random(1)-0.5)+1);
    this.verts =  new PVector[nVerts];
    float angle = TWO_PI/nVerts;
    for(int f = 0; f < nVerts; f++){
      float myangle = f*angle;
      float dist = (random(40) - 20) + 100;
      this.verts[f] = new PVector();
      this.verts[f].x = dist*cos(myangle);
      this.verts[f].y = dist*sin(myangle);
      lowestpt = new PVector(0,0);
      if (dist*sin(myangle) > lowestpt.y){
        lowestpt.y = dist*sin(myangle);
      }
    }
  }
  
  void update() {
    pos.add(vel);
  }
  
  void draw() {
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
  float mp = (p2.y-p1.y)/(p2.x-p1.x);
  float mq = (q2.y-q1.y)/(q2.x-q1.x);
  if (mp == mq) return false;
  float bp = p1.y - mp*p1.x;
  float bq = q1.y - mq*q1.x;
  float x = (bq - bp) / (mp - mq);
  float y = mp*x + bp;
  boolean onP = x >= min(p1.x, p2.x) && x <= max(p1.x, p2.x)
             && y >= min(p1.y, p2.y) && y <= max(p1.y, p2.y);
  boolean onQ = x >= min(q1.x, q2.x) && x <= max(q1.x, q2.x)
             && y >= min(q1.y, q2.y) && y <= max(q1.y, q2.y);
  return onP && onQ;
}
