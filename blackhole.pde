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
  checkForCollisions();
}

void checkForCollisions(){
  Debris[] theD = new Debris[d.size()];
  theD = d.toArray(theD);
  if(theD.length >=2){
  for (int i = 0; i < theD.length-1 ; i++) {
  for (int u = 0; u < theD.length-1 ; u++){
    for (int p = 0; p < theD[i].verts.length-1; p++){
      PVector p1;
      PVector p2;
      if (p == theD[i].verts.length){
       p1 = theD[i].verts[theD[i].verts.length-1];
       p2 = theD[i].verts[0];
      }else{
       p1 = theD[i].verts[p];
       p2 = theD[i].verts[p+1];
      }
    for (int e = 0; e < theD[u].verts.length-1; e++){
      PVector q1;
      PVector q2;
      PVector b1 = new PVector(0,600);
      PVector b2 = new PVector(700,600);
      if (e == theD[u].verts.length){
       q1 = theD[u].verts[theD[u].verts.length-1];
       q2 = theD[u].verts[0];
      }else{
       q1 = theD[u].verts[e];
       q2 = theD[u].verts[e+1];
      }
      if (linesIntersect(p1,p2,q1,q2) == true){
       float newVely = min(theD[i].vel.y,theD[u].vel.y);
       theD[i].vel.y = newVely;
       theD[u].vel.y = newVely; 
      }
    }
    }
   }
   }
 }
}

void generateDebris(){
  if (frame % 180 == 0){
   PVector dpos = new PVector();
   dpos.x = random(width);
   dpos.y = 120;
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
