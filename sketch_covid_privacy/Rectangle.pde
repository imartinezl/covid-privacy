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
    strokeWeight(1);
    noFill();
    rectMode(CENTER);
    rect(this.x, this.y, this.w*2, this.h*2, r);
  }
}
