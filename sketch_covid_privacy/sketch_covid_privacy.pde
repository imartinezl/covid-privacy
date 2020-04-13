
long ts, date; 
int tunit;
ArrayList<Agent> agents;
ArrayList<Environment> envs;
ArrayList<Rectangle> bnds;
Grid grid_hospital, grid_home;
Env_Params residential, industrial; // TO-DO: move to ArrayList
Server server;
GUI gui = new GUI();

PrintWriter output; 
boolean save_result = false;



void init() {
  ts = 0;
  date = 0;
  println("hello");
  tunit = gui.tunit; // time unit: minutes
  envs = new ArrayList<Environment>();
  bnds = new ArrayList<Rectangle>();

  grid_hospital = new Grid("Hospital", 700, 50, 15, 1, 12, 12);
  grid_home = new Grid("Quarantine", 950, 50, 15, 1, 12, 12);

  residential = new Env_Params("Residential", 0, gui.residential_hours, gui.s_residential_max_speed, gui.color_residential);
  industrial = new Env_Params("Industrial", 1, gui.industrial_hours, gui.s_industrial_max_speed, gui.color_industrial);

  server = new Server();
  agents = new ArrayList<Agent>();
}

void init_boundaries() {
  int ww = 500, hh = 500;
  if (gui.env_mode) {
    // grid shape
    float n = ceil(sqrt(gui.env_n)), s = ww/n, m = 10;
    int bnd_cont = 0;
    for (int i=0; i < n; i++) {
      for (int j=0; j < n; j++) {
        bnds.add(new Rectangle(j*(s+m) + s/2 + 50, i*(s+m) + s/2 + 50, s/2, s/2));
        bnd_cont++;
        if (bnd_cont >= gui.env_n) break;
      }
      if (bnd_cont >= gui.env_n) break;
    }
  } else {
    // random shape
    int m = 10;
    for (int i=0; i < gui.env_n; i++) {
      float w = random(10, 50);
      float h = random(10, 50);
      float x = random(m+w, ww-w-m);
      float y = random(m+h, hh-h-m);
      bnds.add(new Rectangle(x, y, w, h));
    }
  }
}

void init_environments() {
  // init environments
  float prob_residential = 0.5;
  for (Rectangle bnd : bnds) {
    Env_Params params;
    if (flip(prob_residential)) {
      params = residential;
    } else {
      params = industrial;
    }
    Environment env = new Environment(bnd, params);
    envs.add(env);
  }
}
void reset() {
  init();
  init_boundaries();
  init_environments();
}

void setup() {
  size(1200, 800);
  //fullScreen();
  gui.cp5 = new ControlP5(this).setPosition(950, 400);
  gui.cp5_control();

  if (save_result) {
    output = createWriter("result.txt"); 
    output.println("ts,agent_A,agent_B,dist");
  }

  init();
  init_boundaries();
  init_environments();

  //server.signup(50, 50, 10);
  //agents.get(0).state.set_infected();
}

void draw() {
  background(gui.color_bgrd);
  if (mousePressed) gui.mouse_pressed();

  // grids
  grid_hospital.update();
  grid_hospital.display();
  grid_home.update();
  grid_home.display();

  // environments
  for (Environment env : envs) {
    env.init_qt();
    env.display();
  }
  // time
  float px = 100, py = 650;
  residential.display_time(px, py);
  industrial.display_time(px, py);
  gui.display_time(px, py);

  // legend
  residential.display_legend(100, 700);
  industrial.display_legend(100, 720);
  gui.display_legend_state(200, 700);
  gui.display_legend_comm(300, 700);
  
  gui.display_info(400, 675);
  
  // env params
  residential.update();
  industrial.update();


  // agents
  for (Agent agent : agents) {
    agent.update();
    agent.display();
    //agent.interact(); BAD
  }
  for (Agent agent : agents) {
    agent.interact();
  }
  if (agents.size() > 0) {
    ts++;
    date += tunit;
  }
}


void exit() {
  //noLoop();
  if (save_result) {
    for (Agent agent : agents) {
      agent.print_register(output);
    }
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
  super.exit(); // Stops the program
} 


boolean flip(float prob) {
  return prob >= random(1);
}
