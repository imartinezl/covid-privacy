
Grid grid = new Grid(0, 0, 400, 400, 2, 2);
ArrayList<Particle> particles = new ArrayList<Particle>(); 

int cont = 0;
void setup() {
  size(800, 800);
  background(250);
  grid.update();
  for (int i=0; i < 500; i++) {
    Particle p = new Particle(cont);
    p.set_grid(grid);
    p.random_pos();
    p.random_vel();
    p.set_acc(new PVector(0,0));
    particles.add(p);
    cont++;
  }
}


void draw() {
  //frameRate(10);
  background(255);
  if(mousePressed){
    for (int i=0; i < 50; i++) {
      Particle p = new Particle(cont);
      p.set_grid(grid);
      p.set_pos(new PVector(mouseX, mouseY));
      p.random_vel();
      p.set_acc(new PVector(0,0));
      particles.add(p);
      cont++;
    }
  }
  fill(0);
  text(frameRate, 10, 20);
  text(cont, 10, 40);
  grid.update();
  grid.display_bnd();
  //grid.display_grid();
  for(Particle p: particles){
    //if(mousePressed) p.attract_to(new PVector(mouseX, mouseY), 10, 10, 100);
    //p.attract_to(new PVector(3*width/4, height/2), 50, 200, 500);
    //p.attract_to(new PVector(1*width/4, height/2), 50, 200, 500);
    //p.attract_to(new PVector(width/2, 1*height/4), 50, 200, 500);
    //p.attract_to(new PVector(width/2, 3*height/4), 50, 200, 500);
    //p.limit_vel(50);
    p.update();
    p.insert();
  }
  for(Particle p: particles){
    //p.search_neighbors(10);
    p.display();
  }
      

}

void display_framerate(){  
  fill(0);
  text(frameRate, 10, 10);
}
