class Grid {
  String title;
  int nx, ny, cell_x, cell_y;
  PVector pos, cell;
  IntList occupied = new IntList();
  Grid(String title, int x, int y, int nx, int ny, int cell_x, int cell_y) {
    this.title = title;
    this.pos = new PVector(x, y);
    this.nx = nx;
    this.ny = ny;
    this.cell_x = cell_x;
    this.cell_y = cell_y;
  }

  PVector get_cell(int id) {
    int px = id % this.nx;
    int py = floor(id / this.nx);
    return new PVector(this.pos.x + px*this.cell_x + this.cell_x/2, this.pos.y + py * this.cell_y + this.cell_y/2);
  }

  void free(int id) {
    if (occupied.hasValue(id)) {
      occupied.removeValue(id);
    }
  }

  int put() {
    int id = 0;
    for (int i=0; i < this.occupied.size(); i++) {
      if (!occupied.hasValue(i)) {
        id = i;
        break;
      }
    }
    if ( id == 0) {
      id = this.occupied.size();
    }
    this.occupied.append(id);
    return id;
  }

  void update() {
    if (this.nx*this.ny <= this.occupied.size()) {
      this.ny = this.ny + 1;
    }
  }

  void display(){
    this.display_grid();
    this.display_title();
  }
  void display_grid() {
    stroke(gui.color_gui, 50);
    strokeWeight(1);
    for (int i=0; i <= this.nx; i++) {
      line(this.pos.x + i*this.cell_x, this.pos.y, this.pos.x + i*this.cell_x, this.pos.y + this.ny*this.cell_y);
    }
    for (int j=0; j <= this.ny; j++) {
      line(this.pos.x, this.pos.y + j*this.cell_y, this.pos.x + this.nx*this.cell_x, this.pos.y + j*this.cell_y);
    }
  }
  
  void display_title(){
    fill(gui.color_gui);
    stroke(gui.color_gui);
    textSize(15);
    textAlign(LEFT, BOTTOM);
    text(title, this.pos.x, this.pos.y);
  }
}
