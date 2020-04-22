import java.util.Map;

class Agent {
  int id;
  Particle particle;
  Environment env, office, room;
  State state;

  float ts_env_switch, ts_arrive, ts_leave;
  float walk_speed=2.0, run_speed = 30, stop_speed = 0.0;
  boolean has_app, flag_reported = false, flag_quarantined = true;
  ArrayList<Contact> register = new ArrayList<Contact>();

  Agent(int id, float x, float y, float r) {
    this.id = id;
    this.particle = new Particle(x, y, r);
    this.state = new State();  
    select_office();

    this.init();
  }

  void select_office() {
    for (Environment env : envs) {
      if (env.bnd.contains(this.particle.pos)) {
        this.office = env;
      }
    }
  }


  Agent(int id, Environment office, float r) {
    this.id = id;
    this.state = new State();    
    this.office = office;

    PVector pos  = this.office.random_pos();
    this.particle = new Particle(pos.x, pos.y, r);

    this.init();
  }

  void init() {
    this.has_app = flip(gui.prob_app);
    this.select_env(this.office);
    this.ts_arrive = this.office.params.ts_start + random(0, 1);
    this.ts_leave = this.office.params.ts_stop + random(-1, 0);
  }

  void select_env(Environment env) {
    this.env = env;
    this.particle.set_bnd(this.env.bnd);
    this.hm_ts = new Sequence();
    this.hm_bt = new Sequence();
  }


  boolean arrived = false, leaved = true;
  void control_env() {
    float hour = date / 60.0 % 24.0;
    if (hour >= ts_arrive && hour <= ts_leave && !arrived) {
      this.select_env(office);
      this.new_env_pos = this.env.bnd.random_pos();
      this.particle.random_move(walk_speed);
      this.arrived = true;
    } else if (hour >= ts_leave) {
      this.particle.random_move(stop_speed);
      this.arrived = false;
    }
  }

  PVector new_env_pos;
  boolean flag_goto = false;
  void go_to(Environment envi) {
    this.select_env(envi);
    this.new_env_pos = envi.bnd.random_pos();
    this.flag_goto = true;
  }

  void move() { 
    if (this.state.cell_home != null) {
      particle.move_to(this.state.cell_home, run_speed);
    } else if (this.state.cell_hospital != null) {
      particle.move_to(this.state.cell_hospital, run_speed);
    } else if (this.state.flag_quarantined) {
      if (this.flag_quarantined) {
        this.select_env(office);
        this.new_env_pos = env.bnd.random_pos();
        this.flag_quarantined = false;
      }
      particle.move_to(this.new_env_pos, run_speed);
      if (particle.pos == this.new_env_pos) {
        this.state.flag_quarantined = false;
        this.particle.random_move(walk_speed);
      }
    } else if (this.flag_goto) {
      this.particle.move_to(this.new_env_pos, run_speed);
      if (particle.pos == this.new_env_pos) {
        this.flag_goto = false;
        this.particle.random_move(walk_speed);
      }
    } else {
      particle.bnd_edges();
    }

    particle.move();
  }

  boolean in_office;
  void update() {
    float hour = date / 60.0 % 24.0;
    in_office = hour > ts_arrive && hour < ts_leave;
    this.control_env();
    this.move(); // move

    this.env.insert(this); // update quadtree
    this.state.update(); // update state  
    this.update_report(); // send alerts
  }

  void update_report() {
    if (!flag_reported && this.state.reported) {
      IntList exposed_ids = new IntList();
      IntList exposed_n = new IntList();
      summarise_register(exposed_ids, exposed_n);
      server.alert(exposed_ids, exposed_n);
      flag_reported = true;
    }
  }

  void alert() {
    this.state.set_alerted();
  }

  float distance(Agent agent) {
    return this.particle.distance(agent.particle);
  }

  Sequence hm_ts = new Sequence();
  Sequence hm_bt = new Sequence();
  void interact() {
    if (in_office) {
      ArrayList <Agent> neighbors = new ArrayList <Agent> ();
      this.env.query(this, neighbors);
      int period_infection = int(gui.period_infection / gui.tunit); //minutes
      int period_connection = int(gui.period_connection / gui.tunit); //minutes
      int period_delete =  int(gui.period_delete)*24*60/ gui.tunit; //days
      this.delete_register(period_delete);
      for (Agent agent : neighbors) {
        if ( agent != this) {
          stroke(255, 100);
          strokeWeight(1);
          line(particle.pos.x, particle.pos.y, agent.particle.pos.x, agent.particle.pos.y);
          if (this.has_app && agent.has_app) { 
            if (flip(gui.prob_bt)) {
              hm_bt.update(agent.id);
              //if (hm_bt.get_value(agent.id) >= period_connection) {
                this.write_register(agent.id, distance(agent));
                hm_bt.delete(agent.id);
              //}
            }
          }

          if (this.state.infected && !this.state.retired) {
            hm_ts.update(agent.id);
            if (hm_ts.get_value(agent.id) >= period_infection && flip(gui.prob_transmission/1000) && !agent.state.infected) {
              agent.state.set_infected();
              hm_ts.delete(agent.id);
            }
          }
        }
      }
      hm_bt.delete(neighbors);
      hm_ts.delete(neighbors);
    }
  }

  void write_register(int id, float dist) {
    register.add(new Contact(ts, date, this.id, id, dist));
  }

  void delete_register(int period_delete) {   
    for (int i = register.size() - 1; i >= 0; i--) {
      Contact c = register.get(i);
      if (ts - c.ts > period_delete) {
        register.remove(i);
      }
    }
  }
  void summarise_register(IntList exposed_ids, IntList exposed_n) {
    for (Contact c : register) {
      int id = c.agent_B;
      if (exposed_ids.hasValue(id)) {
        int pos = exposed_ids.index(id);
        int value = exposed_n.get(pos);
        exposed_n.add(pos, value+1);
      } else {
        exposed_ids.append(id);
        exposed_n.append(1);
      }
    }
  }
  void print_register(PrintWriter output) {
    if (register.size() > 0) {
      for (Contact c : register) {
        c.print_contact(output);
      }
    }
  }

  void display_connection(Particle a, Particle b) {
    stroke(255);
    strokeWeight(2);
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
  }

  void display_state() {
    //if(id == 0) println(ts, this.state.ts_infection, this.state.period_incubation/gui.tunit);
    color c = gui.color_healthy;  
    if (this.state.infected) c = gui.color_infected;
    if (this.state.incubated) c = gui.color_incubated;
    if (this.state.symptoms) c = gui.color_symptoms;
    if (!this.in_office) c = color(c, 180); //gui.color_gray;
    fill(c);
    noStroke();
    circle(this.particle.pos.x, this.particle.pos.y, 3*2);
  }

  void display_comm() {
    color c = gui.color_bgrd;  
    if (this.state.alerted) c = gui.color_alerted;
    if (this.state.reported) c = gui.color_reported;
    //if (this.state.retired) c = gui.color_retired;
    //if (this.state.quarantined) c = gui.color_quarantined;
    if (!this.in_office) c = color(c, 180); //gui.color_gray;
    if ( c != gui.color_bgrd) {
      fill(c);
      noStroke();
      //if (this.has_app) stroke(255);
      circle(this.particle.pos.x, this.particle.pos.y, 4*2);
    }
  }

  float r = 0.0, rp = 0.2;
  void display_radar() {
    color c = gui.color_healthy;  
    if (this.state.infected) c = gui.color_infected;
    if (this.state.incubated) c = gui.color_incubated;
    if (this.state.symptoms) c = gui.color_symptoms;
    noFill();
    stroke(c, 200*(1-r/this.particle.r));
    strokeWeight(1);
    circle(particle.pos.x, this.particle.pos.y, r*2);
    r += rp;
    if (r > this.particle.r) r = 0.0;
  }

  void display() {
    this.display_comm();
    this.display_state();
    if (in_office && !this.state.retired && !this.state.quarantined && this.has_app) {
      this.display_radar();
    }
  }
}



float r = 15;
void init_agents() {
  for (Environment env : envs) {
    if (env.params.type == 0) {
      float area = env.bnd.w*env.bnd.h;
      int n_agents = int(map(area, 300, 3000, 1, 10));
      for (int i=0; i < n_agents; i++) {
        server.signup(env, r);
      }
    }
  }
}
