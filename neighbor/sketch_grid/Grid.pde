class Grid {


  int x, y, nx, ny;
  float hx, hy;
  ArrayList<Particle>[][] cells;

  Grid(int x, int y, int nx, int ny, float hx, float hy) {
    this.x = x;
    this.y = y;
    this.hx = hx;
    this.hy = hy;
    this.nx = nx;
    this.ny = ny;
  }

  int[] idx_to_pos(int idx) {
    int x = idx % nx;
    int y = floor(idx / nx);
    return new int[]{x, y};
  }

  int pos_to_idx(int gx, int gy) {
    return gx + gy*nx;
  }

  boolean check_border(int gx, int gy) {
    return gx == 0 || gy == 0 || gx == nx-1 || gy == ny-1;
  }

  boolean inside(int gx, int gy) {
    return gx >= 0 && gx < nx && gy >= 0 && gy < ny;
  }
  
  int[] clip_inside(int gx, int gy){
    return new int[]{constrain(gx, 0, nx), constrain(gy, 0, ny)};
  }

  int[] random_gp() {
    return new int[]{int(random(nx)), int(random(ny))};
  }
  
  PVector random_pos() {
    return new PVector(random(0, hx*nx), random(0, hy*ny));
  }

  PVector grid_pos(int gx, int gy) {
    return new PVector(grid.x + grid.hx*gx + grid.hx/2, grid.y + grid.hy*gy + grid.hy/2);
  }
  
  PVector real_pos(PVector pos) {
    return new PVector(grid.x + pos.x, grid.y + pos.y);
  }

  int[] neighbor_cells(int gx, int gy, int r) {
    int n = r*2 + 1;
    int[] cells = new int[n*n];
    for (int i=0; i < n; i++) {
      for (int j=0; j < n; j++) {
        int idx = pos_to_idx(gx-1+i, gy-1+j);
        cells[i+j*n] = idx;
      }
    }
    return cells;
  }

  void update() {
    this.cells = new ArrayList[nx][ny];
  }

  void insert(Particle p) {
    if (cells[p.gx][p.gy] == null) cells[p.gx][p.gy] = new ArrayList<Particle>();
    cells[p.gx][p.gy].add(p);
  }

  void display_cell(int gx, int gy){
    pushMatrix();
    translate(x + gx*hx + hx/2, y + gy*hy + hy/2);
    fill(0, 10);
    strokeWeight(1);
    rectMode(CENTER);
    rect(0, 0, hx, hy);
    popMatrix();
  }

  void display_bnd(){
    pushMatrix();
    translate(x, y);
    stroke(0);
    noFill();
    strokeWeight(1);
    rectMode(CORNER);
    rect(0, 0, hx*nx, hy*ny);
    popMatrix();
  }

  void display_grid() {
    pushMatrix();
    translate(x, y);
    stroke(0);
    noFill();
    strokeWeight(0.1);
    for (int i=0; i <= nx; i++) {
      line(i*hx, 0, i*hx, ny*hy);
    }
    for (int j=0; j <= ny; j++) {
      line(0, j*hy, nx*hx, j*hy);
    }
    popMatrix();
  }
}
