PVector q1,q2,p1,p2;
int intersect = 0;
int frame = 0;
ArrayList<Debris> d;

void setup(){
  size(700,600);
  d = new ArrayList<Debris>();
}

void draw(){
  frame++;
  background(200);
  updateAll();
  generateDebris();
}

void checkEdges(){
  if (d.size() > 0){
  for (Debris theD : d) {
    for (Vert myvert : theD.verts){
      
    }
   }
  }
}

void generateDebris(){
  if (frame % 180 == 0){
   PVector dpos = new PVector();
   dpos.x = random(width);
   dpos.y = -400;
   int mverts = int(random(5)+5);
   d.add(new Debris(dpos,mverts));
  } 
}

void updateAll(){
  if(d.size() > 0){
    for (Debris theD : d) {
      theD.update();
      theD.draw();
    }
  }
}
