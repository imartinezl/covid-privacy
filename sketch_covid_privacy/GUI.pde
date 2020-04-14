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

  void display_cp5_title(float x, float y) {
    pushMatrix();
    translate(x, y);
    stroke(this.color_gui, 200);
    strokeWeight(1);
    line(0, 0, wa-2*m, 0);
    fill(this.color_gui);
    textAlign(LEFT, BOTTOM);
    textSize(16);
    text("Parameters", 5, -5);
    popMatrix();
  }

  void cp5_accordion() {
    g1 = cp5.addGroup("myGroup1")
      .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(100)
      .setCaptionLabel("Simulation")
      .setBarHeight(15)
      ;
    g2 = cp5.addGroup("myGroup2")
      .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(100)
      .setCaptionLabel("Environments")
      .setBarHeight(15)
      ;
    g3 = cp5.addGroup("myGroup3")
      .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(120)
      .setCaptionLabel("Periods")
      .setBarHeight(15)
      ;
    g4 = cp5.addGroup("myGroup4")
      .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(80)
      .setCaptionLabel("Probabilities")
      .setBarHeight(15)
      ;
    //g4.getCaptionLabel()
    //  .setFont(font)
    //  .toUpperCase(false)
    //  .setSize(12);
    accordion = cp5.addAccordion("acc")
      //.setPosition(40, 40)
      .setWidth(300) 
      .addItem(g1)
      .addItem(g2)
      .addItem(g3)
      .addItem(g4)
      ;

    accordion.open(0, 1, 2, 3);
    accordion.setCollapseMode(Accordion.MULTI);
  }

  void cp5_setup() {

    cp5.addSlider("tunit")
      .plugTo(this)
      .moveTo(g1)
      .setPosition(10, 10)
      .setRange(1, 10)
      .setValue(1)
      .setNumberOfTickMarks(10)
      .showTickMarks(false)
      ;

    cp5.addButton("reset")
      .plugTo(this)
      .moveTo(g1)
      .setPosition(155, 5)
      .setSize(40, 20)
      ;

    cp5.addToggle("env_mode")
      .plugTo(this)
      .moveTo(g1)
      .setPosition(10, 40)
      .setSize(50, 20)
      .setValue(true)
      .setMode(ControlP5.SWITCH)
      .setCaptionLabel("Env mode")
      ;

    cp5.addNumberbox("env_n")
      .plugTo(this)
      .moveTo(g1)
      .setPosition(80, 40)
      .setSize(100, 20)
      .setMultiplier(0.1)
      .setRange(4, 49)
      .setValue(16)
      .setCaptionLabel("# Env")
      ;

    s_residential_max_speed = cp5.addSlider("residential_max_speed")
      .plugTo(this)
      .moveTo(g2)
      .setPosition(10, 10)
      .setRange(0, 10)
      .setValue(1)
      ;

    s_industrial_max_speed = cp5.addSlider("industrial_max_speed")
      .plugTo(this)
      .moveTo(g2)
      .setPosition(10, 20)
      .setRange(0, 10)
      .setValue(1)
      .linebreak()
      ;

    residential_hours = cp5.addRange("residential_hours")
      .plugTo(this)
      .moveTo(g2)
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 40)
      .setSize(150, 20)
      .setHandleSize(10)
      .setRange(0, 24)
      .setDecimalPrecision(0)
      .setRangeValues(6.1, 9.1)
      // after the initialization we turn broadcast back on again
      .setBroadcast(true)
      .setColorForeground(this.color_residential)
      .setColorBackground(color(255, 40))
      .setColorActive(color(0, 0, 255))
      ;

    industrial_hours = cp5.addRange("industrial_hours")
      .plugTo(this)
      .moveTo(g2)
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
      .setPosition(10, 60)
      .setSize(150, 20)
      .setHandleSize(10)
      .setRange(0, 24)
      .setDecimalPrecision(0)
      .setRangeValues(17.1, 20.1)
      // after the initialization we turn broadcast back on again
      .setBroadcast(true)
      .setColorForeground(this.color_industrial)
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
      .setPosition(10, 10)
      .setRange(1, 21)
      .setValue(7)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      ;

    cp5.addSlider("period_symptoms")
      .plugTo(this)
      .moveTo(g3)
      .setPosition(10, 20)
      .setRange(1, 21)
      .setValue(5)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)      
      .setDecimalPrecision(0)
      ;

    cp5.addSlider("period_report")
      .plugTo(this)
      .moveTo(g3)
      .setPosition(10, 30)
      .setRange(1, 21)
      .setValue(2)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)      
      .setDecimalPrecision(0)
      ;

    cp5.addSlider("period_retire")
      .plugTo(this)
      .moveTo(g3)
      .setPosition(10, 40)
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
      .setPosition(10, 50)
      .setRange(1, 21)
      .setValue(14)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      ;

    cp5.addSlider("prob_symptoms")
      .plugTo(this)
      .moveTo(g4)
      .setPosition(10, 10)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;

    cp5.addSlider("prob_retire")
      .plugTo(this)
      .moveTo(g4)
      .setPosition(10, 20)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      ;

    cp5.addSlider("prob_report")
      .plugTo(this)
      .moveTo(g4)
      .setPosition(10, 30)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;
  }
  float period_infection, period_connection, period_delete;
  float prob_app, prob_bt, prob_transmission;
  void cp5_agent() {
    cp5.addSlider("period_delete")
      .plugTo(this)
      .moveTo(g3)
      .setPosition(10, 60)
      .setRange(1, 21)
      .setValue(14)
      .setNumberOfTickMarks(21)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      //.linebreak()
      ;
    cp5.addSlider("period_infection")
      .plugTo(this)
      .moveTo(g3)
      .setPosition(10, 80)
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
      .setPosition(10, 90)
      .setRange(1, 20)
      .setValue(10)
      .setNumberOfTickMarks(20)
      .showTickMarks(false)
      .setDecimalPrecision(0)
      //.linebreak()
      ;

    cp5.addSlider("prob_app")
      .plugTo(this)
      .moveTo(g4)
      .setPosition(10, 40)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;

    cp5.addSlider("prob_bt")
      .plugTo(this)
      .moveTo(g4)
      .setPosition(10, 50)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(11)
      .showTickMarks(false)
      //.linebreak()
      ;
    cp5.addSlider("prob_transmission")
      .plugTo(this)
      .moveTo(g4)
      .setPosition(10, 60)
      .setRange(0, 1)
      .setValue(1)
      .setNumberOfTickMarks(21)
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
          server.signup(pos.x, pos.y, 15);
          if (mouseButton == RIGHT) {
            agents.get(agents.size()-1).state.set_infected();
          }
        }
      }
    }
  }

  int wa, wb, wc, m;
  void setup_layout() {
    wa = int(0.25*width); 
    wb = int(0.5625*width);
    wc = int(width-wa-wb);
    m = int(height*0.03);
  }
  void display_layout() {
    noFill();
    stroke(255);
    //rect(0,0, wa, height);
    //rect(wa,0, wb, height);
    //rect(wa+wb,0, wc, height);
    strokeWeight(1);
    line(wa, m, wa, height-m);
    line(wa+wb, m, wa+wb, height-m);
  }

  void display_title(float x, float y) {
    pushMatrix();
    translate(x, y);
    fill(this.color_gui);
    noStroke();
    textSize(40);
    textAlign(LEFT, TOP);
    textLeading(45);
    text("Privacy-preserving\nContact-tracing", 0, 0);
    popMatrix();
  }

  void display_info(float x, float y) {
    pushMatrix();
    translate(x, y);
    fill(this.color_gui);
    noStroke();
    int txt_size = 12;
    textSize(txt_size);
    String txt = "FPS: " + round(frameRate)  + "  # Agents: " + agents.size();
    text(txt, 0, 0);
    popMatrix();
  }

  void display_state_distribution(float x, float y) {
    pushMatrix();
    translate(x, y);

    popMatrix();
  }

  void display_time(float x, float y) {
    float kx = 13, ky = 20;
    float day = round(date/60/24);
    float hour = round(date/60 % 24);
    float minutes = round(date % 60);

    pushMatrix();
    translate(x, y);

    // title
    stroke(this.color_gui, 200);
    strokeWeight(1);
    line(0, 0, wa-2*m, 0);
    fill(this.color_gui);
    textAlign(LEFT, BOTTOM);
    textSize(16);
    text("Timeline", 5, -5);

    translate(20, 40);

    // timeline
    stroke(this.color_gui);
    strokeWeight(1);
    fill(this.color_gui);
    textAlign(CENTER, TOP);
    textSize(12);

    for (int i=0; i <= 24; i++) {
      if (i % 2 == 0) {
        text(str(i), kx*i, 1.1*ky);
        line(kx*i, 0, kx*i, ky);
      } else {
        line(kx*i, ky/4, kx*i, 3*ky/4);
      }
    }

    //current tile
    stroke(this.color_gui);
    strokeWeight(2);
    //strokeCap(1);
    pushMatrix();
    translate((hour + minutes/60)*kx, 0);
    // triangle
    float s = 12;
    fill(this.color_gui);
    noStroke();
    triangle(0, 0, -s/2, -s, s/2, -s); 
    // hour
    fill(this.color_gui);
    noStroke();
    textSize(14);
    textAlign(CENTER, BOTTOM);
    text(nf(int(hour), 2) + ":" + nf(int(minutes), 2), 0, -s);
    popMatrix();

    // day
    pushMatrix();
    translate(24*kx + 50, ky/2);
    textSize(14);
    textAlign(CENTER, CENTER);
    text("Day: "+str(int(day)), 0, 0);
    noFill();
    stroke(this.color_gui);
    strokeWeight(1);
    rectMode(CENTER);
    rect(0, 0, 60, 1.5*ky, 5);
    popMatrix();

    popMatrix();
  }

  void display_legend_title(float x, float y) {

    pushMatrix();
    translate(x, y);
    stroke(this.color_gui, 200);
    strokeWeight(1);
    line(0, 0, wa-2*m, 0);
    fill(this.color_gui);
    textAlign(LEFT, BOTTOM);
    textSize(16);
    text("Legend", 5, -5);
    popMatrix();
  }

  void display_legend_state(float x, float y) {
    color[] colors_legend = new color[]{color_healthy, color_infected, color_incubated, color_symptoms};
    String[] colors_text = new String[]{"Healthy", "Infected", "Incubating", "Symptoms"};
    float s = 25;
    for (int i=0; i < colors_legend.length; i++) {
      pushMatrix();
      translate(x, y + i*s);

      noStroke();
      fill(colors_legend[i]);
      circle(0, -7, 10);

      fill(this.color_gui);
      textAlign(LEFT);
      textSize(14);
      text(colors_text[i], s, 0);
      popMatrix();
    }
  }

  void display_legend_comm(float x, float y) {
    color[] colors_legend = new color[]{color_reported, color_alerted, color_retired, color_quarantined};
    String[] colors_text = new String[]{"Report", "Alerted", "Retired", "Quarantine"};
    float s = 25;
    for (int i=0; i < colors_legend.length; i++) {
      pushMatrix();
      translate(x, y + i*s);

      noStroke();
      fill(colors_legend[i]);
      circle(0, -7, 14);
      fill(this.color_bgrd);
      circle(0, -7, 10);

      fill(this.color_gui);
      textAlign(LEFT);
      textSize(14);
      text(colors_text[i], s, 0);
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
