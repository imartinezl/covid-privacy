import java.util.Map;

class Agent {
  int id;
  Particle particle;
  Environment env, office, room;
  State state;

  float ts_env_switch, ts_arrive, ts_leave;
  boolean has_app, flag_reported = false, flag_quarantined = true;
  ArrayList<Contact> register = new ArrayList<Contact>();

  Agent(int id, float x, float y, float r) {
    this.id = id;
    this.particle = new Particle(x, y, r);
    this.state = new State();  
    select_office();

    this.ts_arrive = 8 + random(0, 1);
    this.ts_leave = 17.5 + random(-1, 0);

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
    this.ts_arrive = 8 + random(0, 1);
    this.ts_leave = 17.5 + random(-1, 0);

    PVector pos  = this.office.random_pos();
    this.particle = new Particle(pos.x, pos.y, r);

    this.init();
  }

  void init() {
    this.has_app = flip(gui.prob_app);
    this.env = this.office;
    this.select_current_env();
  }

  void select_current_env() {
    this.particle.set_bnd(this.env.bnd);
    this.hm_ts = new Sequence();
    this.hm_bt = new Sequence();
  }

  PVector new_env_pos;
  boolean arrived = false, leaved = true;
  void control_env() {
    float hour = date / 60.0 % 24.0;
    if (hour >= ts_arrive && hour <= ts_leave && !arrived) {
      this.env = this.office;
      this.select_current_env();
      this.new_env_pos = this.env.bnd.random_pos();
      this.particle.max_speed = 1;
      this.particle.random_move();
      this.arrived = true;
    } else if (hour >= ts_leave) {
      this.particle.max_speed = 0;
      this.arrived = false;
    }
  }

  void move() { 
    float switch_speed = 10;
    if (this.state.cell_home != null) {
      particle.move_to(this.state.cell_home, switch_speed);
    } else if (this.state.cell_hospital != null) {
      particle.move_to(this.state.cell_hospital, switch_speed);
    } else if (this.state.flag_quarantined) {
      if (this.flag_quarantined) {
        this.select_current_env();
        this.new_env_pos = env.bnd.random_pos();
        this.flag_quarantined = false;
      }
      particle.move_to(this.new_env_pos, switch_speed);
      if (particle.pos == this.new_env_pos) {
        this.state.flag_quarantined = false;
        this.particle.random_move();
      }
      //} else if (this.env_switch) {
      //  particle.move_to(this.new_env_pos, switch_speed);
      //  if (particle.pos == this.new_env_pos) {
      //    this.env_switch = false;
      //    this.particle.random_move();
      //  }
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

          if (this.has_app) { // and if(this.resting = false) only monitor in working place
            if (flip(gui.prob_bt)) {
              hm_bt.update(agent.id);
              if (hm_bt.get_value(agent.id) >= period_connection) {
                this.write_register(agent.id, distance(agent));
                hm_bt.delete(agent.id);
              }
            }
          }

          if (this.state.infected && !this.state.retired) {
            hm_ts.update(agent.id);
            if (hm_ts.get_value(agent.id) >= period_infection && flip(gui.prob_transmission) && !agent.state.infected) {
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
    register.add(new Contact(ts, this.id, id, dist));
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
    if (!this.in_office) c = gui.color_gray;
    fill(c);
    noStroke();
    circle(this.particle.pos.x, this.particle.pos.y, 4*2);
  }

  void display_comm() {
    color c = gui.color_bgrd;  
    if (this.state.alerted) c = gui.color_alerted;
    if (this.state.reported) c = gui.color_reported;
    //if (this.state.retired) c = gui.color_retired;
    //if (this.state.quarantined) c = gui.color_quarantined;
    if (!this.in_office) c = gui.color_gray;
    if ( c != gui.color_bgrd) {
      fill(c);
      noStroke();
      //if (this.has_app) stroke(255);
      circle(this.particle.pos.x, this.particle.pos.y, 5*2);
    }
  }

  float r = 0.0, rp = 0.2;
  void display_radar() {
    color c = gui.color_healthy;  
    if (this.state.infected) c = gui.color_infected;
    if (this.state.incubated) c = gui.color_incubated;
    if (this.state.symptoms) c = gui.color_symptoms;
    noFill();
    stroke(c, 255*(1-r/this.particle.r));
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
