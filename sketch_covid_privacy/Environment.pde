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
  float max_speed; Slider s_max_speed;
  Range hours;
  color c;
  Env_Params(String name, int type, Range hours, Slider s_max_speed, color c) {
    this.name = name;
    this.type = type;
    this.hours = hours;
    this.s_max_speed = s_max_speed;
    this.c = c;
  }

  void update() {
    this.ts_start = int(this.hours.getArrayValue(0));
    this.ts_stop = int(this.hours.getArrayValue(1));
    this.max_speed = this.s_max_speed.getValue();
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
    int kx = 10, ky = 10;

    pushMatrix();
    translate(x, y);
    fill(this.c);
    noStroke();
    rectMode(CORNER);
    rect(this.ts_start*kx, ky/4, (this.ts_stop-this.ts_start)*kx, ky);
    popMatrix();
  }
}
