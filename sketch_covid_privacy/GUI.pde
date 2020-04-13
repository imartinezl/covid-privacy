import controlP5.*;

class GUI {
  GUI() {
  }
  ControlP5 cp5;

  int tunit;
  void control() {

    cp5.addSlider("tunit")
      .plugTo(this)
      .setPosition(0, 0)
      .setRange(1, 10)
      .setValue(1)
      .setNumberOfTickMarks(10)
      ;

    cp5.addButton("reset")
      .setValue(0)
      .setPosition(100, 100)
      .setSize(200, 19)
      ;
  }

  color color_gui = color(255);
  color color_bgrd = color(20);

  color color_residential = color(146, 57, 246, 150);
  color color_industrial = color(255, 0, 118, 150);

  color color_healthy = color(255, 255, 255);
  color color_infected = color(255, 255, 0);
  color color_incubated = color(255, 151, 0);
  color color_symptoms = color(255, 0, 0);

  color color_alerted = color(0, 77, 255);
  color color_retired = color(120, 120, 120);
  color color_reported = color(0, 255, 0);
  color color_quarantined = color(120, 120, 120);

  void mouse_pressed() {
    for (int i=0; i < 10; i++) {
      PVector pos = new PVector(mouseX + random(-10, 10), mouseY + random(-10, 10));
      for (Environment env : envs) {
        if (env.bnd.contains(pos)) {
          server.signup(pos.x, pos.y, 10);
          if (mouseButton == RIGHT) {
            agents.get(agents.size()-1).state.set_infected();
          }
        }
      }
    }
  }

  void display_info() {
    fill(this.color_gui);
    noStroke();
    textSize(10);
    text(str(round(ts)), 25, 25);
    text(str(round(frameRate)), 25, 45);
    text(str(agents.size()), 25, 65);
  }

  void display_state_dist(float x, float y) {
    pushMatrix();
    translate(x, y);

    popMatrix();
  }

  void display_time(float x, float y) {
    float kx = 10, ky = 15;
    float day = round(date/60/24);
    float hour = round(date/60 % 24);
    float minutes = round(date % 60);

    pushMatrix();
    translate(x, y);

    // timeline
    stroke(this.color_gui);
    strokeWeight(1);
    fill(this.color_gui);
    textAlign(CENTER, TOP);
    for (int i=0; i <= 24; i++) {
      if (i % 2 == 0) {
        text(str(i), kx*i, ky);
        line(kx*i, 0, kx*i, ky);
      } else {
        line(kx*i, ky/4, kx*i, 3*ky/4);
      }
    }
    // day
    text("Day: "+str(int(day)), -30, 0);

    //current tile
    stroke(this.color_gui);
    strokeWeight(2);
    //strokeCap(1);
    pushMatrix();
    translate((hour + minutes/60)*kx, 0);
    // triangle
    float s = 8;
    fill(this.color_gui);
    noStroke();
    triangle(0, 0, -s/2, -s, s/2, -s); 
    // hour
    fill(this.color_gui);
    noStroke();
    textSize(10);
    textAlign(CENTER, BOTTOM);
    text(nf(int(hour), 2) + ":" + nf(int(minutes), 2), 0, -s);
    popMatrix();

    popMatrix();
  }

  void display_legend_state(float x, float y) {
    color[] colors_legend = new color[]{color_healthy, color_infected, color_incubated, color_symptoms};
    String[] colors_text = new String[]{"Healthy", "Infected", "Incubating", "Symptoms"};
    for (int i=0; i < colors_legend.length; i++) {
      pushMatrix();
      translate(x, y + i*20);

      fill(colors_legend[i]);
      circle(-20, 5, 8);

      fill(this.color_gui);
      textAlign(LEFT, TOP);
      textSize(10);
      text(colors_text[i], 0, 0);
      popMatrix();
    }
  }

  void display_legend_comm(float x, float y) {
    color[] colors_legend = new color[]{color_reported, color_alerted, color_retired, color_quarantined};
    String[] colors_text = new String[]{"Report", "Alerted", "Retired", "Quarantine"};
    for (int i=0; i < colors_legend.length; i++) {
      pushMatrix();
      translate(x, y + i*20);

      fill(colors_legend[i]);
      circle(-20, 5, 12);
      fill(this.color_bgrd);
      circle(-20, 5, 8);

      fill(this.color_gui);
      textAlign(LEFT, TOP);
      textSize(10);
      text(colors_text[i], 0, 0);
      popMatrix();
    }
  }

  void display_bnds() {
    for (Rectangle rectA : bnds) {
      int id = int(random(bnds.size()));
      Rectangle rectB = bnds.get(id);
      //for (Rectangle rectB : bnds) {
      //  if (rectA != rectB) {
      stroke(255, 50);
      line(rectA.x, rectA.y, rectB.x, rectB.y);
    }
  }

  void display() {
    display_info();
    //display_bnds();
  }
}
