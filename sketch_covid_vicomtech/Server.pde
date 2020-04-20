import java.util.Map;

class Server {

  Server() {
  }

  void signup(Environment office, float r) {
    Agent agent = new Agent(agents.size(), office, r);
    agents.add(agent);
  }
  void signup(float x, float y, float r) {
    Agent agent = new Agent(agents.size(), x, y, r);
    agents.add(agent);
  }

  void alert(IntList exposed_ids, IntList exposed_n) {
    for (int id: exposed_ids) {
      agents.get(id).alert();
    }
  }
}
