PVector q1,q2,p1,p2;
int intersect = 0;
Debris a;

void setup(){
  size(700,600);
  q1 = new PVector(40, 40);
  q2 = new PVector(90,200);
  p1 = new PVector(350,300);
  p2 = new PVector(600, 500);
  PVector apos = new PVector(350,300);
  int averts = 10;
  a = new Debris(apos,averts);
}

void draw(){
  p2.x = mouseX;
  p2.y = mouseY;
  background(200);
  line(q1.x,q1.y,q2.x,q2.y);
  line(p1.x,p1.y,p2.x,p2.y);
  a.draw();
  if (linesIntersect(q1,q2,p1,p2) == true){
    intersect = 1;
  }else{
    intersect = 0;
  }
  dispIntersect();
}

void dispIntersect(){
  if (intersect == 0){
   text("not intersecting",300,50);
  }else{
   text("intersecting",300,50);
  }
}
