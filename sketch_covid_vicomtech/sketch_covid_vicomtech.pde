
long ts, date; 
int tunit;
ArrayList<Agent> agents;
ArrayList<Environment> envs;
ArrayList<Rectangle> bnds;
ArrayList<Meeting> meetings;

Grid grid_hospital, grid_home;
Env_Params office, room;
Server server;
GUI gui = new GUI();

PrintWriter output; 
boolean save_result = false;

PFont font;

void init() {
  ts = 0;
  date = 0;
  println("hello");
  tunit = gui.tunit; // time unit: minutes
  envs = new ArrayList<Environment>();
  bnds = new ArrayList<Rectangle>();
  meetings = new ArrayList<Meeting>();

  grid_hospital = new Grid("Hospital", gui.m+gui.wa+gui.wb, 2*gui.m, 15, 1, 12, 12);
  grid_home = new Grid("Quarantine", gui.m+gui.wa+gui.wb, 3*height/4-gui.m, 15, 1, 12, 12);

  office = new Env_Params("Office", 0, gui.office_hours, gui.color_office);
  room = new Env_Params("Room", 1, gui.room_hours, gui.color_room);

  server = new Server();
  agents = new ArrayList<Agent>();
}

void init_boundaries() {
  int ww = height - 2*gui.m, hh = ww;
  if (gui.env_mode) {
    // grid shape
    float n = ceil(sqrt(gui.env_n)), m = 10, s = ww/n - m, off_w = gui.wb-ww+m;
    int bnd_cont = 0;
    for (int i=0; i < n; i++) {
      for (int j=0; j < n; j++) {
        bnds.add(new Rectangle(gui.wa + j*(s+m) + s/2 + off_w/2, gui.m + i*(s+m) + s/2 + m/2, s/2, s/2));
        bnd_cont++;
        if (bnd_cont >= gui.env_n) break;
      }
      if (bnd_cont >= gui.env_n) break;
    }
  } else {
    // random shape
    for (int i=0; i < gui.env_n; i++) {
      float w = random(10, 50);
      float h = random(10, 50);
      float x = gui.wa + random(gui.m+w, ww-w-gui.m);
      float y = random(gui.m+h, hh-h-gui.m);
      bnds.add(new Rectangle(x, y, w, h));
    }
  }
}

void init_environments() {

  for (int i=0; i < bnds.size(); i++) {
    Env_Params params;
    if (i < bnds.size()/2) {
      params = office;
    } else {
      params = room;
    }
    Environment env = new Environment(bnds.get(i), params);
    envs.add(env);
  }

  //float prob_office = 0.5;
  //for (Rectangle bnd : bnds) {
  //  Env_Params params;
  //  if (flip(prob_office)) {
  //    params = office;
  //  } else {
  //    params = room;
  //  }
  //  Environment env = new Environment(bnd, params);
  //  envs.add(env);
  //}
}
void reset() {
  init();
  init_boundaries();
  init_environments();
}

void setup() {
  size(1920, 1080);
  //fullScreen(SPAN);

  font = createFont("Poppins-Regular.ttf", 20, true);
  textFont(font);

  // layout
  gui.setup_layout();

  gui.cp5 = new ControlP5(this).setPosition(gui.m, 590);
  gui.cp5_control();

  if (save_result) {
    output = createWriter("result.txt"); 
    output.println("ts,agent_A,agent_B,dist");
  }

  init();
  init_boundaries();
  init_environments();

  ArrayList<Agent> participants = new ArrayList<Agent>();
  for (int i=0; i < 10; i++) {
    server.signup(envs.get(0), 10);
    if(flip(0.3)){
      participants.add(agents.get(i));
    }
  }
  meetings.add(new Meeting(envs.get(12), 13, 14, participants));
}

void draw() {
  background(gui.color_bgrd);
  if (mousePressed) gui.mouse_pressed();

  //layout
  gui.display_layout();
  gui.display_title(gui.m, gui.m);
  gui.display_info(gui.m, height-gui.m);
  gui.display_cp5_title(gui.m, 570);

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
  float px = gui.m, py = gui.m + 350;
  office.display_time(px, py);
  room.display_time(px, py);
  gui.display_time(px, py);

  // legend
  px = gui.m; 
  py = gui.m + 170;
  gui.display_legend_title(px, py);
  gui.display_legend_state(px+ 20, py+30);
  gui.display_legend_comm(px + 200, py+30);

  // env params
  office.update();
  room.update();


  // agents
  for (Agent agent : agents) {
    agent.update();
    agent.display();
  }

  for (Agent agent : agents) {
    agent.interact();
  }
  ts++;
  date += tunit;
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
