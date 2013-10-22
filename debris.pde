
class Debris {
  PVector[] verts;
  PVector pos;
  PVector vel;
  
  Debris(PVector pos, PVector[] verts){
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.verts = verts;
  }
  
  void update() {
  }
  
  void draw() {
    beginShape();
    for (int j = 0; j <= verts.length; j++){
      vertex(pos.x + verts[j].x, pos.y + verts[j].y);
    }
    endShape(CLOSE);
  }
}

boolean linesIntersect(PVector p1, PVector p2, PVector q1, PVector q2) {
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
