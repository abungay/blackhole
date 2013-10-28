class Man extends Debris {
  Man(PVector pos) {
    super(pos);
    this.vel = new PVector(0, 0);
    this.verts = new PVector[]{
      new PVector(30,0),
      new PVector(45,0),
      new PVector(54,5),
      new PVector(57,14),
      new PVector(57,24),
      new PVector(53,31),
      new PVector(46,37),
      new PVector(47,42),
      new PVector(61,58),
      new PVector(75,74),
      new PVector(70,80),
      new PVector(56,66),
      new PVector(46,56),
      new PVector(45,101),
      new PVector(51,117),
      new PVector(57,134),
      new PVector(46,134),
      new PVector(42,120),
      new PVector(37,104),
      new PVector(33,120),
      new PVector(30,134),
      new PVector(18,134),
      new PVector(22,116),
      new PVector(29,100),
      new PVector(28,56),
      new PVector(19,65),
      new PVector(7,80),
      new PVector(0,74),
      new PVector(14,58),
      new PVector(28,42),
      new PVector(30,37),
      new PVector(22,32),
      new PVector(18,24),
      new PVector(18,13),
      new PVector(22,5)
    };
    for(int f = 0; f < this.verts.length; f++){
      this.verts[f].x -= 37;
      this.verts[f].y -= 73;
    }
  }
}
