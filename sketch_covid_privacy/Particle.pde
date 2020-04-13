class Particle {
  PVector pos, vel, acc;
  Rectangle bnd;
  float r;
  float max_speed = 1.0;

  Particle(float x, float y, float r) {
    this.pos = new PVector(x, y);
    this.vel = new PVector(random(-max_speed, max_speed), random(-max_speed, max_speed));
    this.acc = new PVector(0, 0);
    this.r = r;
  }
  
  void set_bnd(Rectangle bnd){
    this.bnd = bnd;
  }

  float distance(Particle p) {
    return dist(this.pos.x, this.pos.y, p.pos.x, p.pos.y);
  }
  float distanceSq(Particle p) {
    return pow(p.pos.x-this.pos.x, 2) + pow(p.pos.y-this.pos.y, 2);
  }
  boolean contains(Particle p) {
    return( distanceSq(p) < pow(this.r, 2) );
  }
  
  void apply_force(PVector force) {
    float mass = 1;
    force.div(mass);
    this.acc.add(force);
  }

  void attract_to(PVector goal) {
    PVector dir = PVector.sub(this.pos, goal);
    float d = dir.mag();
    dir.normalize();
    d = constrain(d, 10, 20);
    float strength = 1;
    float force = -1 * strength / (d*d);
    dir.mult(force);
    apply_force(dir);
  }
  
  void move_to(PVector goal, float step){
    this.vel.mult(0);
    if(dist(goal.x, goal.y, this.pos.x, this.pos.y) > step){
      PVector dir = PVector.sub(goal, this.pos);
      dir.normalize();
      this.vel = dir.mult(step);
    }else{
      this.pos = goal;
    }
  }

  void move() {
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }

  void random_move() {
    this.vel = PVector.fromAngle(random(2*PI));
    //this.vel = new PVector(random(-1,1), random(-this.max_speed, this.max_speed));
  }
  
  void set_max_speed(float max_speed){
    this.max_speed = max_speed;
    this.vel.setMag(this.max_speed);
  }

  void bnd_edges() {
    if (this.pos.x > this.bnd.x + this.bnd.w || 
      this.pos.x < this.bnd.x - this.bnd.w ) {
      this.vel.x *= -1;
    }
    if (this.pos.y > this.bnd.y + this.bnd.h || 
      this.pos.y < this.bnd.y - this.bnd.h ) {
      this.vel.y *= -1;
    }
  }
}
