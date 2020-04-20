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
  
  PVector random_pos(){
    return this.bnd.random_pos();
  }
}

class Env_Params {
  String name;
  int type, ts_start, ts_stop;
  Range hours;
  color c;
  Env_Params(String name, int type, Range hours, color c) {
    this.name = name;
    this.type = type;
    this.hours = hours;
    this.c = c;
  }

  void update() {
    this.ts_start = int(this.hours.getArrayValue(0));
    this.ts_stop = int(this.hours.getArrayValue(1));
    //this.c = gui.color_residential;
  }

  void display_legend(float x, float y) {
    pushMatrix();
    translate(x, y);

    fill(this.c);
    rectMode(CORNER);
    rect(-20, 0, 15, 12, 3);

    fill(gui.color_gui);
    textAlign(LEFT, TOP);
    text(this.name, 0, 0);
    popMatrix();
  }

  void display_time(float x, float y) {
    int kx = 13, ky = 15;
    
    float m = this.ts_stop-this.ts_start;

    pushMatrix();
    translate(x, y);
    translate(20, 40);
    fill(this.c);
    noStroke();
    rectMode(CORNER);
    rect(this.ts_start*kx, ky/4, m*kx, ky);
    
    int e = 0;
    if(name == "Room") e = 40;
    
    noFill();
    stroke(this.c);
    strokeWeight(2);
    line((this.ts_start+m/2)*kx, 5*ky/4, (this.ts_start+m/2)*kx, 4*ky + e);
    
    fill(this.c);
    rectMode(CENTER);
    rect((this.ts_start+m/2)*kx, 9*ky/2 + e, 10*name.length(), ky, 4);
    
    fill(gui.color_gui);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(this.name,(this.ts_start+m/2)*kx, 4.25*ky + e); 
    
    popMatrix();
  }
}
