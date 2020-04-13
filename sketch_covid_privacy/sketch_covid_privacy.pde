GUI gui = new GUI();

long ts; int tunit;
ArrayList<Agent> agents;
ArrayList<Environment> envs;
ArrayList<Rectangle> bnds;
Grid grid_hospital, grid_home;
Env_Params residential, industrial;
Server server;

PrintWriter output; 
boolean save_result = false;

void init() {
  ts = 0;
  tunit = 10; // time unit: minutes
  envs = new ArrayList<Environment>();
  bnds = new ArrayList<Rectangle>();

  grid_hospital = new Grid("Hospital", 700, 50, 15, 1, 12, 12);
  grid_home = new Grid("Quarantine", 950, 50, 15, 1, 12, 12);

  residential = new Env_Params("Residential", 0, 6, 9, 1, gui.color_residential);
  industrial = new Env_Params("Industrial", 1, 17, 20, 1, gui.color_industrial);

  server = new Server();
  agents = new ArrayList<Agent>();
}

void init_boundaries() {
  // init boundaries
  // grid shape
  float n = 3, s = 200, m = 10;
  for (int i=0; i < n; i++) {
    for (int j=0; j < n; j++) {
      bnds.add(new Rectangle(i*(s+m) + s/2 + 50, j*(s+m) + s/2 + 50, s/2, s/2));
    }
  }
  // random shape
  //for (int i=0; i < 20; i++) {
  //  float w = random(10, 50);
  //  float h = random(10, 50);
  //  float x = random(10+w, 600-w-10);
  //  float y = random(10+h, 600-h-10);
  //  bnds.add(new Rectangle(x, y, w, h));
  //}
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

void setup() {
  size(1200, 800);
  gui.cp5 = new ControlP5(this);
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
  float px = 900, py = 550;
  residential.display_time(px, py);
  industrial.display_time(px, py);
  gui.display_time(px, py);

  // legend
  residential.display_legend(600, 550);
  industrial.display_legend(600, 570);
  gui.display_legend_state(700, 550);
  gui.display_legend_comm(800, 550);

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
  }
  gui.display();

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
