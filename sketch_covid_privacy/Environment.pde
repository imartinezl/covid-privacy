class Environment {
  QuadTree qt;
  Rectangle bnd;
  Env_Params params;


  Environment(Rectangle bnd, Env_Params params) {
    this.bnd = bnd;
    this.params = params;
  }
  void init_qt() {
    this.qt = new QuadTree(this.bnd, 4);
  }

  void insert(Agent agent) {
    this.qt.insert(agent);
  }

  void query(Agent agent, ArrayList<Agent> found) {
    this.qt.query(agent, found);
  }

  float ts_switch() {
    return random(this.params.ts_start, this.params.ts_stop);
  }
  

  void display() {
    this.bnd.display(this.params.c, 3);
    //this.qt.display();
  }
}

class Env_Params {
  String name;
  int type, ts_start, ts_stop;
  float max_speed;
  color c;
  Env_Params(String name, int type, int ts_start, int ts_stop, float max_speed, color c) {
    this.name = name;
    this.type = type;
    this.ts_start = ts_start;
    this.ts_stop = ts_stop;
    this.max_speed = max_speed;
    this.c = c;
  }
  
  void display_legend(float x, float y){
    pushMatrix();
    translate(x,y);
    
    fill(this.c);
    rectMode(CORNER);
    rect(-20, 0, 15, 12, 3);
    
    fill(gui.color_gui);
    textAlign(LEFT, TOP);
    text(this.name, 0, 0);
    popMatrix();
  }
  
  void display_time(float x, float y){
    int kx = 10, ky = 10;
    
    pushMatrix();
    translate(x,y);
    fill(this.c);
    noStroke();
    rectMode(CORNER);
    rect(this.ts_start*kx, ky/4, (this.ts_stop-this.ts_start)*kx, ky);
    popMatrix();
    
  }
  
}
