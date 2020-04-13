import controlP5.*;

class GUI {
  GUI() {
  }
  ControlP5 cp5;
  Accordion accordion;
  Group g1, g2, g3, g4;

  int tunit, env_n;
  float residential_max_speed, industrial_max_speed;
  Range residential_hours, industrial_hours;
  Slider s_residential_max_speed, s_industrial_max_speed;
  boolean env_mode;
  void cp5_control() {
    this.cp5_accordion();
    this.cp5_setup();
    this.cp5_state();
    this.cp5_agent();
  }

  void cp5_accordion() {
    g1 = cp5.addGroup("myGroup1")
      .setSize(200, 100)
      .setBackgroundColor(color(0, 64))
      ;
    g2 = cp5.addGroup("myGroup2")
      .setSize(200, 400)
      .setBackgroundColor(color(0, 64))
      ;
    g3 = cp5.addGroup("myGroup3")
      .setSize(200, 100)
      .setBackgroundColor(color(0, 64))
      ;
    g4 = cp5.addGroup("myGroup4")
      .setSize(200, 100)
      .setBackgroundColor(color(0, 64))
      ;
    accordion = cp5.addAccordion("acc")
      //.setPosition(40, 40)
      //.setWidth(200)
      .addItem(g1)
      .addItem(g2)
      .addItem(g3)
      .addItem(g4)
      ;
    accordion.open(1);
  }

  void cp5_setup() {

    cp5.addSlider("tunit")
      .plugTo(this)
      .moveTo(g1)
      //.setPosition(0,0)
      .setRange(1, 10)
      .setValue(1)
      .setNumberOfTickMarks(10)
      .showTickMarks(false)
      //.linebreak()
      ;

    cp5.addButton("reset")
      .plugTo(this)
      .moveTo(g1)
      .setSize(40, 20)
      .linebreak()
      ;

    cp5.addToggle("env_mode")
      .plugTo(this)
      .moveTo(g1)
      .setSize(50, 20)
      .setValue(true)
      .setMode(ControlP5.SWITCH)
      .setCaptionLabel("Env mode")
      //.linebreak()
      ;

    cp5.addNumberbox("env_n")
      .plugTo(this)
      .moveTo(g1)
      .setSize(100, 20)
      .setMultiplier(0.1)
      .setRange(4, 49)
      .setValue(16)
      .setCaptionLabel("# Env")
      .linebreak()
      ;

    s_residential_max_speed = cp5.addSlider("residential_max_speed")
      .plugTo(this)
      .moveTo(g2)
      .setPosition(0,0)
      .setRange(0, 10)
      .setValue(1)
      .linebreak()
      ;

    s_industrial_max_speed = cp5.addSlider("industrial_max_speed")
      .plugTo(this)
      .moveTo(g2)
      .setRange(0, 10)
      .setValue(1)
      .linebreak()
      ;

    residential_hours = cp5.addRange("residential_hours")
      .plugTo(this)
      .moveTo(g2)
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(0, 100)
      .setSize(200, 20)
      .setHandleSize(10)
      .setRange(0, 24)
      .setDecimalPrecision(0)
      .setRangeValues(6.1, 9.1)
      // after the initialization we turn broadcast back on again
      .setBroadcast(true)
      .setColorForeground(color(255, 0, 0))
      .setColorBackground(color(255, 40))
      .setColorActive(color(0, 0, 255))
      ;

    industrial_hours = cp5.addRange("industrial_hours")
      .plugTo(this)
      .moveTo(g2)
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(0, 170)
      .setSize(200, 20)
      .setHandleSize(10)
      .setRange(0, 24)
      .setDecimalPrecision(0)
      .setRangeValues(17.1, 20.1)
      // after the initialization we turn broadcast back on again
      .setBroadcast(true)
      .setColorForeground(color(255, 0, 0))
      .setColorBackground(color(255, 40))
      .setColorActive(color(0, 0, 255))
      ;
  }
  float period_incubation, period_symptoms, period_report, period_retire, period_quarantine;
  float prob_symptoms, prob_retire, prob_report;
  void cp5_state() {
    cp5.addSlider("period_incubation")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 21)
      .setValue(7)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      //.linebreak()
      ;

    cp5.addSlider("period_symptoms")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 21)
      .setValue(5)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)      
      .setDecimalPrecision(0)
      //.linebreak()
      ;

    cp5.addSlider("period_report")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 21)
      .setValue(2)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)      
      .setDecimalPrecision(0)
      //.linebreak()
      ;

    cp5.addSlider("period_retire")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 21)
      .setValue(2)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)      
      .setDecimalPrecision(0)
      //.linebreak()
      ;

    cp5.addSlider("period_quarantine")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 21)
      .setValue(14)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      //.linebreak()
      ;

    cp5.addSlider("prob_symptoms")
      .plugTo(this)
      .moveTo(g4)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;

    cp5.addSlider("prob_retire")
      .plugTo(this)
      .moveTo(g4)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;

    cp5.addSlider("prob_report")
      .plugTo(this)
      .moveTo(g4)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;
  }
  int period_infection, period_connection, period_delete;
  float prob_app, prob_bt, prob_transmission;
  void cp5_agent() {
    cp5.addSlider("period_infection")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 20)
      .setValue(10)
      .setNumberOfTickMarks(20)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      //.linebreak()
      ;
    cp5.addSlider("period_connection")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 20)
      .setValue(10)
      .setNumberOfTickMarks(20)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      //.linebreak()
      ;
    cp5.addSlider("period_delete")
      .plugTo(this)
      .moveTo(g3)
      .setRange(1, 21)
      .setValue(14)
      .setNumberOfTickMarks(20)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      //.linebreak()
      ;
    cp5.addSlider("prob_app")
      .plugTo(this)
      .moveTo(g4)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;

    cp5.addSlider("prob_bt")
      .plugTo(this)
      .moveTo(g4)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;
    cp5.addSlider("prob_transmission")
      .plugTo(this)
      .moveTo(g4)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
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
    for (int i=0; i < 5; i++) {
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

  void display_info(float x, float y) {
    pushMatrix();
    translate(x, y);
    fill(this.color_gui);
    noStroke();
    textSize(10);
    text("TS: " + str(round(ts)), 25, 25);
    text("FPS: " + str(round(frameRate)), 25, 45);
    text("# Agents: " + str(agents.size()), 25, 65);
    popMatrix();
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
    //display_info();
    //display_bnds();
  }
}
