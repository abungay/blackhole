int frame = 0;
ArrayList<Debris> d;
PVector accel;
Boolean movinghoriz = false;
Boolean maninair = true;
Boolean manonground = false;
Boolean manonpoly = false;
Boolean dead = false;
int deadmillis = 0;
String deadtext = "";
float blackholesize = 5;
ArrayList<Debris> mcols;
Man m;

void setup() {
  size(700, 600);
  accel = new PVector(0, 0.1633);
  d = new ArrayList<Debris>();
  mcols = new ArrayList<Debris>();
  m = new Man(new PVector(350, 530));
}

void draw() {
  if (!dead){
  frame++;
  blackholesize += 0.4;
  m.vel.add(accel);
  m.pos.add(m.vel);
  if (!movinghoriz){
  if (m.vel.x > 0.01){
    accel.x = -0.1;
  }else if(m.vel.x < -0.01){
    accel.x = 0.1;
  }else if(m.vel.x >= -0.01 && m.vel.x <= 0.01){
    accel.x = 0;
    m.vel.x = 0;
  }
  }else{
   accel.x = 0; 
  }
  background(200);
  translate(0,400-m.pos.y); //make camera follow man
  updateAll();
  generateDebris();
  fill(100,100,100);
  rect(0,601,700,601);
  fill(0);
  ellipse(350,800,blackholesize,blackholesize);
  textSize(30);
  text("Height: " + int(-(m.pos.y-558)/20) + "ft",500,m.pos.y-350);
  checkForCollisions();
  checkOffScreen();
  checkBlackHole();
  }else{
     fill(200,200,200);
     textSize(50);
     text("YOU DIED!",200,300);
     textSize(30);
     text(deadtext,200,400);
    if(millis() - deadmillis > 5000){
     dead = false;
     maninair = true;
     frame = 0;
     d = new ArrayList<Debris>();
     mcols = new ArrayList<Debris>();
     m = new Man(new PVector(350, 530));
     blackholesize = 5;
    }
  }
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

Boolean IsPolyOffScreen(Debris d1){
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
  int crush = 0;
  if (theD.length >=2) {
    for (int i = 0; i < theD.length; i++) {
            if (polygonIntersection(theD[i],m)) {
              while (polygonIntersection(theD[i],m)) {
                m.pos.x += ((m.pos.x-theD[i].pos.x)/(abs(m.pos.x-theD[i].pos.x)))*0.1;
                m.pos.y += ((m.pos.y-theD[i].pos.y)/(abs(m.pos.y-theD[i].pos.y)))*0.1;
                crush++;
              }
              maninair = false;
              mcols.add(theD[i]);
              //if (theD[i].vel.y == 0){
                maninair = false;
                m.vel.y = 0;
                manonpoly = true;
              //}
            }else{
             if (mcols.contains(theD[i])) {
               mcols.remove(theD[i]);
             }
             if (mcols.size() == 0){
               manonpoly = false;
             }
            }
      for (int j = 0; j < theD.length; j++) {
            if (polygonIntersection(theD[i],theD[j]) == true){
              float newVely = min(theD[i].vel.y, theD[j].vel.y);
              theD[i].vel.y = newVely;
              theD[j].vel.y = newVely;
            }
        }
      }
    }
    if (crush > 200 && (maninair == false)){
     restartGame(0);
    }
  }
  
void checkOffScreen(){
  Debris[] theD = new Debris[d.size()];
  theD = d.toArray(theD);
  if (m.pos.y > -200){
  for (int i = 0; i < theD.length; i++) {
    if (IsPolyOffScreen(theD[i]) == true){
      theD[i].vel.y = 0;
    } 
   }
  }
  if (m.pos.y > 600 - 42.7){
    m.pos.y = 600 - 42.7;
    manonground = true;
    m.vel.y = 0;
  }else{
    manonground = false;
    if (manonpoly = false){
     maninair = true; 
    }
   }
  if (m.pos.x > 700 + 25.9 && m.vel.x > 0){
   m.pos.x = -26.6; 
  }
  if (m.pos.x < -26.6 && m.vel.x < 0){
   m.pos.x = 700 + 25.9; 
  }
}

void checkBlackHole(){
//  Debris[] theD = new Debris[d.size()];
//  theD = d.toArray(theD);
//  for (int i = 0; i < theD.length; i++) {
//    if (dist(theD[i].pos.x,theD[i].pos.y,350,800) <= blackholesize){
//     theD[i].remove 
//    }
//  }
  for (Debris theD : d) {
    if (dist(theD.pos.x,theD.pos.y,350,800) <= blackholesize/2){
     d.remove(theD);
    }
  }
  if (dist(m.pos.x,m.pos.y,350,800) <= blackholesize/2){
   restartGame(1); 
  }
}

void generateDebris() {
  if (frame % 180 == 0 && d.size() < 40) {
    PVector dpos = new PVector();
    dpos.x = random(width);
    dpos.y = m.pos.y-520;
    int mverts = int(random(5)+5);
    d.add(new Debris(dpos, mverts));
  }
}

void updateAll() {
  fill(0,0,255);
  m.update();
  m.draw();
  if (d.size() > 0) {
    for (Debris theD : d) {
      fill(theD.R,theD.G,theD.B);
      theD.update();
      theD.draw();
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      m.vel.x = 1.5;
      movinghoriz = true;
    }else if (keyCode == LEFT) {
      m.vel.x = -1.5;
      movinghoriz = true;
    }
    if (keyCode == UP) {
      if (maninair = false || m.vel.y == 0) {
        maninair = true;
        m.vel.y = -6;
      }
    }
  }
}

void keyReleased(){
  if (key == CODED) {
    if (keyCode == RIGHT) {
      movinghoriz = false;
    }else if (keyCode == LEFT) {
      movinghoriz = false;
    }
  }
}

void restartGame(int cause){
  switch(cause){
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

