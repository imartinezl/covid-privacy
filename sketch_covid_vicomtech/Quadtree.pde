class QuadTree {
  Rectangle boundary;
  int capacity;
  ArrayList<Agent> agents;
  boolean divided = false;

  QuadTree northwest, northeast, southwest, southeast;

  QuadTree(Rectangle boundary, int n) {
    this.boundary = boundary;
    this.capacity = n;
    this.agents = new ArrayList<Agent>();
  }

  boolean insert(Agent agent) {
    if (!this.boundary.contains(agent.particle)) {
      return false;
    }
    
    if (agents.size() < this.capacity) {
      this.agents.add(agent);
      return true;
    } else {
      if ( !this.divided) {
        this.subdivide();
      }
      if (this.northwest.insert(agent)) {
        return true;
      } else if (this.northeast.insert(agent)) {
        return true;
      } else if (this.southwest.insert(agent)) {
        return true;
      } else if (this.southeast.insert(agent)) {
        return true;
      } else {
        return false;
      }
    }
  }

  void subdivide() {
    float x = this.boundary.x;
    float y = this.boundary.y;
    float w = this.boundary.w;
    float h = this.boundary.h;


    Rectangle nw = new Rectangle(x - w/2, y - h/2, w/2, h/2);
    this.northwest = new QuadTree(nw, this.capacity);
    Rectangle ne = new Rectangle(x + w/2, y - h/2, w/2, h/2);
    this.northeast = new QuadTree(ne, this.capacity);
    Rectangle sw = new Rectangle(x - w/2, y + h/2, w/2, h/2);
    this.southwest = new QuadTree(sw, this.capacity);
    Rectangle se = new Rectangle(x + w/2, y + h/2, w/2, h/2);
    this.southeast = new QuadTree(se, this.capacity);

    this.divided = true;
  }

  void query(Agent agent, ArrayList<Agent> found) {
    if (this.boundary.intersects(agent.particle)) {
      for(Agent draft: this.agents){
        if(agent.particle.contains(draft.particle)){
          found.add(draft);
        }
      }
      if(this.divided){
        this.northwest.query(agent, found);
        this.northeast.query(agent, found);
        this.southwest.query(agent, found);
        this.southeast.query(agent, found);
      }
    }
  }


  void display() {
    stroke(255);
    strokeWeight(1);
    noFill();
    rectMode(CENTER);
    rect(this.boundary.x, this.boundary.y, this.boundary.w*2, this.boundary.h*2);
    if (this.divided) {
      this.northwest.display();
      this.northeast.display();
      this.southwest.display();
      this.southeast.display();
    }
  }
}
