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
  
  boolean intersects(PVector p, float r){
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
  
  PVector random_pos(){
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
