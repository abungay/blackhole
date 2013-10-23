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
  if (d.size() >= 2 && frame > 500){
  for (int i = 0; i < d.size() ; i++) {
  for (int u = 0; i < d.size(); u++){
    for (int p = 0; p < d.get(i).verts.length; p++){
      PVector p1;
      PVector p2;
      if (p == d.get(i).verts.length-1){
       p1 = d.get(i).verts[d.get(i).verts.length-1];
       p2 = d.get(i).verts[0];
      }else{
       p1 = d.get(i).verts[p];
       p2 = d.get(i).verts[p+1];
      }
    for (int e = 0; e < d.get(u).verts.length; e++){
      PVector q1;
      PVector q2;
      if (e == d.get(u).verts.length-1){
       q1 = d.get(u).verts[d.get(u).verts.length-1];
       q2 = d.get(u).verts[0];
      }else{
       q1 = d.get(u).verts[e];
       q2 = d.get(u).verts[e+1];
      }
      if (linesIntersect(p1,p2,q1,q2) == true){
       float newVely = min(d.get(i).vel.y,d.get(u).vel.y = 0);
       d.get(i).vel.y = newVely;
       d.get(u).vel.y = newVely; 
       println("one of the polygons is touching another one!");
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
