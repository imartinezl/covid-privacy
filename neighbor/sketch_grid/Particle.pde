import java.util.Random;
class Particle {

  Grid grid;
  int id, gx, gy;
  PVector pos, vel, acc;
  float px, py, vx, vy;
  ArrayList<Particle> neighbors;
  ArrayList<PVector> trace = new ArrayList<PVector>();

  Particle(int id) {
    this.id = id;
  }

  void set_grid(Grid grid) {
    this.grid = grid;
  }

  void set_pos(PVector pos) {
    this.pos = pos;
  }

  void set_vel(PVector vel) {
    this.vel = vel;
  }
  
  void set_acc(PVector acc) {
    this.acc = acc;
  }

  void set_gp(int gx, int gy) {
    this.gx = gx;
    this.gy = gy;
  }

  void limit_vel(float max_vel) {
    vel.limit(max_vel);
  }

  void random_gp() {
    int[] rp = grid.random_gp();
    set_gp(rp[0], rp[1]);
  }

  void random_pos() {
    set_pos(grid.random_pos());
  }

  void random_vel() {
    PVector vel = PVector.fromAngle(random(2*PI));
    vel.mult(random(5));
    set_vel(vel);
  }

  void insert() {
    grid.insert(this);
  }

  void search_neighbors(int r) {
    neighbors = new ArrayList<Particle>();

    int n = r*2 + 1;
    for (int i=0; i < n; i++) {
      for (int j=0; j < n; j++) {
        if (grid.inside(gx-r+i, gy-r+j)) {
          //grid.display_cell(gx-r+i, gy-r+j);
          ArrayList<Particle> tmp = grid.cells[gx-r+i][gy-r+j];
          if (tmp != null && tmp.size() > 0) {
            for (Particle p : tmp) {
              if (p.id != id){ neighbors.add(p); }
            }
          }
        }
      }
    }
  }



  void pos_to_grid() {
    int gx = constrain(int(pos.x/grid.hx), 0, grid.nx-1);
    int gy = constrain(int(pos.y/grid.hy), 0, grid.ny-1);
    set_gp(gx, gy);
  }

  void edges() {
    if (pos.x < 0) {
      pos.x = 0; 
      vel.x *= -1;
    }
    if (pos.x > grid.hx*grid.nx) {
      pos.x = grid.hx*grid.nx; 
      vel.x *= -1;
    }
    if (pos.y < 0) {
      pos.y = 0; 
      vel.y *= -1;
    }
    if (pos.y > grid.hy*grid.ny) {
      pos.y = grid.hy*grid.ny; 
      vel.y *= -1;
    }
  }
  
  void move(){
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }

  void update() {
    move();
    edges();
    pos_to_grid();
    //add_trace();
  }
  
  void apply_force(PVector force) {
    float mass = 1;
    force.div(mass);
    this.acc.add(force);
  }

  void attract_to(PVector goal, float min_dist, float max_dist, float strength) {
    PVector dir = PVector.sub(this.pos, goal);
    float d = dir.mag();
    dir.normalize();
    d = constrain(d, min_dist, max_dist);
    //float strength = 20;
    float force = -1 * strength / (d*d);
    dir.mult(force);
    apply_force(dir);
  }
  
  void add_trace(){
   trace.add(grid.real_pos(pos));
   int n_max = 2000;
   if(trace.size() > n_max){
     trace.remove(0);
   }
  }
    


  void display() {
    //display_neighbors();
    display_particle();
    //display_trace();
  }

  void display_neighbors() {
    PVector me = grid.real_pos(pos);
    stroke(0, 100);
    strokeWeight(1);
    for (Particle p : neighbors) {
      PVector you = grid.real_pos(p.pos);
      line(me.x, me.y, you.x, you.y);
    }
  }

  PVector pre;
  void display_particle() {
    pushMatrix();
    PVector me = grid.real_pos(pos);
    translate(me.x, me.y);
    fill(0, 50);
    noStroke();
    circle(0, 0, 6);
    //noFill();
    //stroke(0, map(dist(me.x, me.y, 400, 400), 300, 400, 1, 0));
    //strokeWeight(random(2));
    //if(pre != null) line(pre.x, pre.y, me.x, me.y); 
    //pre = me;
    popMatrix();
  }
  
  void display_trace(){
    noFill();
    stroke(0, 50);
    strokeWeight(0.1);
    beginShape();
    for(PVector p: trace){
      vertex(p.x, p.y);
    }
    endShape();
  }
}
