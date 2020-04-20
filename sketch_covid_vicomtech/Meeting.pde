class Meeting {

  float ts_start, ts_stop;
  ArrayList<Agent> participants;
  Environment room;

  Meeting(Environment room, float ts_start, float ts_stop, ArrayList<Agent> participants ) {
    this.room = room;
    this.ts_start = ts_start;
    this.ts_stop = ts_stop;
    this.participants = participants;
  }

  boolean flag_go = false, flag_return = true;
  void update() {
    float hour = date / 60.0 % 24.0;
    if (hour > ts_start && hour < ts_stop && !flag_go) {
      for (Agent agent : participants) {
        agent.go_to(room);
      }
      flag_go = true;
      flag_return = false;
    } else if (hour > ts_stop && !flag_return) {
      for (Agent agent : participants) {
        if (agent.env == room) {
          agent.go_to(agent.office);
        }
      }
      flag_return = true;
      flag_go = false;
    }
  }
}

void init_meetings() {
  int n_meetings = 10;
  for (int i=0; i < n_meetings; i++) {
    // people
    ArrayList<Agent> participants = new ArrayList<Agent>();
    int n_people = int(random(2, 6));
    for (int j=0; j < n_people; j++) {
      int id = int(random(agents.size()));
      participants.add(agents.get(id));
    }
    
    // room
    int room_id = int(random(rooms.size()));
    
    // hours
    float ts_start = random(9, 16);
    float ts_stop = ts_start + random(1, 3);
    meetings.add(new Meeting(rooms.get(room_id), ts_start, ts_stop, participants));
  }
}
