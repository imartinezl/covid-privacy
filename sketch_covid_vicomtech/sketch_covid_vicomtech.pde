
long ts, date; 
int tunit;
ArrayList<Agent> agents;
ArrayList<Environment> envs, offices, rooms;
ArrayList<Rectangle> bnds;
ArrayList<Meeting> meetings;

Grid grid_hospital, grid_home;
Env_Params office, room;
Server server;
GUI gui = new GUI();

PrintWriter output; 
boolean save_result = false;

PImage logo, plan_A, plan_B, plan_C, plan_D, plan_E;
PFont font;

void init() {
  ts = 0;
  date = 0;
  println("hello");
  tunit = gui.tunit; // time unit: minutes
  envs = new ArrayList<Environment>();
  offices = new ArrayList<Environment>();
  rooms = new ArrayList<Environment>();
  bnds = new ArrayList<Rectangle>();
  meetings = new ArrayList<Meeting>();

  grid_hospital = new Grid("Hospital", gui.m+gui.wa+gui.wb, height/4-gui.m, 25, 1, 12, 12);
  grid_home = new Grid("Quarantine", gui.m+gui.wa+gui.wb, 2*gui.m, 25, 1, 12, 12);

  office = new Env_Params("Office", 0, gui.office_hours, gui.color_office);
  room = new Env_Params("Room", 1, gui.room_hours, gui.color_room);

  server = new Server();
  agents = new ArrayList<Agent>();
}

void reset() {
  init();
  if (gui.env_custom) {
    init_custom_boundaries();
    init_custom_environments();
  } else {
    init_boundaries();
    init_environments();
  }
  init_agents();
  init_meetings();
}

boolean start = false;
void run() {
  start = !start;
}

void setup() {
  size(1920, 1080);

  font = createFont("Poppins-Regular.ttf", 20, true);
  textFont(font);
  logo = loadImage("LOGO_BRTA.png");
  float scl = 0.6;
  plan_A = loadImage("SalasReuniones57_A-min.png");
  plan_A.resize(int(plan_A.width*scl), int(plan_A.height*scl));
  plan_B = loadImage("SalasReuniones57_B-min.png");
  plan_B.resize(int(plan_B.width*scl), int(plan_B.height*scl));
  scl = 0.5;
  plan_C = loadImage("SalasReuniones71_A-min.png");
  plan_C.resize(int(plan_C.width*scl), int(plan_C.height*scl));
  scl = 0.6;
  plan_D = loadImage("SalasReuniones63_A-min.png");
  plan_D.resize(int(plan_D.width*scl), int(plan_D.height*scl));
  plan_E = loadImage("SalasReuniones63_B-min.png");
  plan_E.resize(int(plan_E.width*scl), int(plan_E.height*scl));


  // layout
  gui.setup_layout();

  gui.cp5 = new ControlP5(this).setPosition(gui.m + 20, 590);
  gui.cp5_control();

  if (save_result) {
    output = createWriter("result.txt"); 
    output.println("ts,agent_A,agent_B,dist");
  }

  reset();
}

void draw() {
  background(gui.color_bgrd);
  if (mousePressed) gui.mouse_pressed();

  //layout
  //gui.display_grid();
  gui.display_layout();
  gui.display_title(gui.m, gui.m);
  gui.display_info(gui.m, height-gui.m);
  gui.display_cp5_title(gui.m, 570);
  if (gui.env_custom) gui.display_plans();

  // grids
  grid_hospital.update();
  grid_hospital.display();
  grid_home.update();
  grid_home.display();

  // environments
  for (Environment env : envs) {
    env.init_qt();
    if (!gui.env_custom) env.display();
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
  gui.display_legend_state(px + 20, py+30);
  gui.display_legend_comm(px + 200, py+30);

  // env params
  office.update();
  room.update();

  // meetings
  if (date % (60*24) < tunit) init_meetings();
  for (Meeting m : meetings) {
    m.update();
  }

  // agents
  for (Agent agent : agents) {
    agent.update();
    agent.display();
  }

  for (Agent agent : agents) {
    agent.interact();
  }
  gui.display_state(gui.wa + gui.wb + gui.m, height/2);

  if (start) {
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
