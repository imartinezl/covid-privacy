class Sequence {
  HashMap<Integer, Integer> hm = new HashMap<Integer, Integer>();

  Sequence() {
  }

  void update(int id) {
    if (!hm.containsKey(id)) {
      hm.put(id, 0);
    } else {
      int n = hm.get(id);
      hm.put(id, n+1);
    }
  }

  int get_value(int id) {
    return hm.get(id);
  }
  void delete(int id){
    hm.remove(hm.get(id));
  }
  void delete(ArrayList <Agent> neighbors) {
    for (Map.Entry me : hm.entrySet()) {
      boolean exists = false;
      for (Agent agent : neighbors) {
        if (hm.containsKey(agent.id)) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        hm.remove(me);
      }
    }
  }
}
