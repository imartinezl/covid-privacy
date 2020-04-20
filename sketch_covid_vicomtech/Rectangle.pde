class Rectangle {
  float x, y, w, h;

  Rectangle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  boolean contains(PVector p) {
    boolean inside = p.x >= this.x - this.w && 
      p.x <= this.x + this.w &&
      p.y >= this.y - this.h &&
      p.y <= this.y + this.h;
    return inside;
  }

  boolean contains(Particle p) {
    return this.contains(p.pos);
  }

  boolean intersects(PVector p, float r) {
    float dist_x = abs(p.x - this.x);
    float dist_y = abs(p.y - this.y);

    if (dist_x > (this.w + r)) { 
      return false;
    }
    if (dist_y > (this.h + r)) { 
      return false;
    }

    if (dist_x <= (this.w)) { 
      return true;
    } 
    if (dist_y <= (this.h)) { 
      return true;
    }

    float dist_corner = pow(dist_x - this.w, 2) + pow(dist_y - this.h, 2);
    return (dist_corner <= pow(r, 2));
  }
  boolean intersects(Particle p) {
    return this.intersects(p.pos, p.r);
  }

  PVector random_pos() {
    return new PVector(random(this.x-this.w, this.x+this.w), random(this.y-this.h, this.y+this.h));
  }

  void display(color c, float r) {
    stroke(c);
    strokeWeight(2);
    noFill();
    rectMode(CENTER);
    rect(this.x, this.y, this.w*2, this.h*2, r);
  }
}



void init_boundaries() {
  int ww = height - 2*gui.m, hh = ww;
  if (gui.env_mode) {
    // grid shape
    float n = ceil(sqrt(gui.env_n)), m = 10, s = ww/n - m, off_w = gui.wb-ww+m;
    int bnd_cont = 0;
    for (int i=0; i < n; i++) {
      for (int j=0; j < n; j++) {
        bnds.add(new Rectangle(gui.wa + j*(s+m) + s/2 + off_w/2, gui.m + i*(s+m) + s/2 + m/2, s/2, s/2));
        bnd_cont++;
        if (bnd_cont >= gui.env_n) break;
      }
      if (bnd_cont >= gui.env_n) break;
    }
  } else {
    // random shape
    for (int i=0; i < gui.env_n; i++) {
      float w = random(10, 50);
      float h = random(10, 50);
      float x = gui.wa + random(gui.m+w, ww-w-gui.m);
      float y = random(gui.m+h, hh-h-gui.m);
      bnds.add(new Rectangle(x, y, w, h));
    }
  }
}

IntList bnd_type;
void init_custom_boundaries() {

  bnd_type = new IntList(); // 0: office, 1: room
  // 57 planta baja
  float scl = 0.6;
  PVector origin = new PVector(gui.wa + gui.m + 150, gui.m);

  new_rect(origin, new PVector(42, 83), new PVector(40, 76), scl, 0); // Recepcion
  new_rect(origin, new PVector(120, 45), new PVector(65, 80), scl, 1); // Txomin agirre
  new_rect(origin, new PVector(255, 40), new PVector(95, 50), scl, 0); // Admin 1
  new_rect(origin, new PVector(345, 150), new PVector(55, 100), scl, 0); // Admin 2
  new_rect(origin, new PVector(250, 220), new PVector(50, 35), scl, 1); // Aita Donostia
  new_rect(origin, new PVector(250, 290), new PVector(47.5, 30), scl, 1); // Escudero
  new_rect(origin, new PVector(270, 350), new PVector(89, 95), scl, 0); // V3
  new_rect(origin, new PVector(260, 540), new PVector(80, 85), scl, 0); // V1
  new_rect(origin, new PVector(215, 695), new PVector(32, 36), scl, 0); // Despacho1
  new_rect(origin, new PVector(285, 710), new PVector(32, 35), scl, 1); // Madina
  new_rect(origin, new PVector(350, 725), new PVector(30, 32), scl, 0); // Despacho2
  new_rect(origin, new PVector(45, 580), new PVector(72, 65), scl, 0); // Lab1

  // 57 planta alta
  scl = 0.6;
  origin = new PVector(gui.wa + gui.m + 550, gui.m);

  new_rect(origin, new PVector(250, 495), new PVector(35, 35), scl, 1); // Bilintx
  new_rect(origin, new PVector(225, 220), new PVector(45, 28), scl, 1); // Txirrita
  new_rect(origin, new PVector(225, 155), new PVector(45, 30), scl, 1); // Xenpelar
  new_rect(origin, new PVector(115, 170), new PVector(54, 73), scl, 0); // Sistemas
  new_rect(origin, new PVector(370, 150), new PVector(60, 70), scl, 0); // TT1
  new_rect(origin, new PVector(340, 340), new PVector(72, 70), scl, 0); // TT2
  new_rect(origin, new PVector(115, 560), new PVector(80, 50), scl, 0); // V6
  new_rect(origin, new PVector(340, 515), new PVector(70, 70), scl, 0); // V4
  new_rect(origin, new PVector(330, 670), new PVector(35, 35), scl, 1); // Xalbador
  new_rect(origin, new PVector(255, 665), new PVector(33, 33), scl, 0); // Despacho V4-1
  new_rect(origin, new PVector(405, 685), new PVector(30, 38), scl, 0); // Despacho V4-2
  new_rect(origin, new PVector(255, 55), new PVector(34, 38), scl, 0); // Despacho TT-1
  new_rect(origin, new PVector(335, 55), new PVector(33, 38), scl, 0); // Despacho TT-2
  new_rect(origin, new PVector(410, 40), new PVector(30, 42), scl, 0); // Despacho TT-3
  new_rect(origin, new PVector(158, 60), new PVector(45, 45), scl, 1); // Sala TT

  // 71
  scl = 0.5;
  origin = new PVector(gui.wa + gui.m + 600, gui.m+500);

  new_rect(origin, new PVector(55, 30), new PVector(135, 70), scl, 1); // Katalina Erauso
  new_rect(origin, new PVector(460, 300), new PVector(175, 100), scl, 1); // Random-1
  new_rect(origin, new PVector(275, 615), new PVector(209, 100), scl, 0); // Pradera
  new_rect(origin, new PVector(730, 610), new PVector(36, 50), scl, 0); // Despacho-1
  new_rect(origin, new PVector(730, 730), new PVector(36, 45), scl, 0); // Despacho-2
  new_rect(origin, new PVector(60, 190), new PVector(70, 65), scl, 1); // Guridi
  new_rect(origin, new PVector(70, 330), new PVector(68, 50), scl, 1); // Sorozabal
  new_rect(origin, new PVector(70, 445), new PVector(70, 45), scl, 1); // Iruarrizaga
  new_rect(origin, new PVector(60, 555), new PVector(70, 115), scl, 1); // Random-2
  new_rect(origin, new PVector(470, 510), new PVector(84, 46), scl, 1); // Random-3

  // 63 planta baja
  scl = 0.6;
  origin = new PVector(gui.wa + gui.m, gui.m + 550);

  new_rect(origin, new PVector(315, 400), new PVector(50, 50), scl, 1); // Etxepare
  new_rect(origin, new PVector(225, 495), new PVector(50, 50), scl, 0); // Reunion-1
  new_rect(origin, new PVector(50, 272), new PVector(65, 85), scl, 0); // Pradera-1
  new_rect(origin, new PVector(45, 110), new PVector(70, 75), scl, 0); // Pradera-2
  new_rect(origin, new PVector(225, 70), new PVector(70, 45), scl, 0); // Reunion-2
  new_rect(origin, new PVector(290, 160), new PVector(35, 35), scl, 1); // Lizardi
  new_rect(origin, new PVector(190, 200), new PVector(25, 40), scl, 1); // Reunion-3
  new_rect(origin, new PVector(36, 445), new PVector(25, 38), scl, 0); // Despacho-1 
  new_rect(origin, new PVector(100, 455), new PVector(23, 40), scl, 0); // Despacho-2 
  new_rect(origin, new PVector(160, 470), new PVector(23, 40), scl, 0); // Despacho-3

  // 63 primera planta
  scl = 0.6;
  origin = new PVector(gui.wa + gui.m + 300, gui.m + 550);

  new_rect(origin, new PVector(45, 330), new PVector(75, 90), scl, 1); // Auditorio
  new_rect(origin, new PVector(295, 395), new PVector(55, 48), scl, 0); // Oficina-1
  new_rect(origin, new PVector(215, 494), new PVector(90, 45), scl, 1); // Axular
  new_rect(origin, new PVector(315, 150), new PVector(50, 32), scl, 1); // Iparraguirre 
  new_rect(origin, new PVector(195, 60), new PVector(25, 50), scl, 1); // Reunion-1
  new_rect(origin, new PVector(30, 110), new PVector(80, 55), scl, 0); // Pradera-1
  new_rect(origin, new PVector(40, 225), new PVector(60, 45), scl, 0); // Pradera-2
}

void new_rect(PVector origin, PVector corner, PVector sides, float scl, int type) {
  corner = corner.mult(scl);
  sides = sides.mult(scl);
  bnds.add(new Rectangle(origin.x + corner.x + sides.x, origin.y + corner.y + sides.y, sides.x, sides.y)); 
  bnd_type.append(type);
}
