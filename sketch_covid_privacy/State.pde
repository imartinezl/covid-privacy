class State {

  long ts_infection, ts_incubated, ts_symptoms, ts_reported, ts_retired, ts_alerted, ts_quarantined;
  boolean infected, incubated, symptoms, reported, retired, alerted, quarantined;
  PVector cell_home, cell_hospital;
  int cell_home_id, cell_hospital_id;

  long period_incubation = 7*24*60 / tunit, period_symptoms = 5*24*60 / tunit, period_report = 2*60 / tunit, period_retire = 2*60 / tunit, period_quarantine = 14*24*60 / tunit;  
  float prob_symptoms, prob_retire, prob_report;
  boolean flag_symptoms, flag_retired, flag_reported, flag_alerted, flag_quarantined = false;

  State() {
    init();
  }

  void init() {
    println(period_incubation);
    this.prob_symptoms = 1; // probability of having symptoms after being infected
    this.prob_retire = 1; // probability of a symptomatic person to retire to their home
    this.prob_report = 1; // probability of a symptomatic person to report their status

    this.infected = false;
    this.incubated = false;
    this.symptoms = false;
    this.reported = false;
    this.retired = false;
    this.alerted = false;
    this.quarantined = false;

    this.flag_symptoms = false;
    this.flag_retired = false; 
    this.flag_reported = false;
    this.flag_alerted=false;

    this.cell_home = null;
    this.cell_hospital = null;
  }

  void set_infected() {
    this.infected = true;
    this.ts_infection = ts;
  }

  void set_incubated() {
    this.incubated = true;
    this.ts_incubated = ts;
  }

  void set_symptoms() {
    this.symptoms = true;
    this.ts_symptoms = ts;
  }

  void set_reported() {
    this.reported = true;
    this.ts_reported = ts;
  }

  void set_retired() {
    this.retired = true;
    this.ts_retired = ts;

    this.update_outdoors();
  }

  void set_alerted() {
    this.alerted = true;
    this.ts_alerted = ts;
  }

  void set_quarantined() {
    this.quarantined = true;
    this.ts_quarantined = ts;
    
    this.update_outdoors();
  }

  void update_incubated() {
    if ( this.infected && (ts - this.ts_infection > this.period_incubation) && !this.incubated) {
      this.set_incubated();
    }
  }

  void update_symptoms() {
    if (this.incubated && (ts - this.ts_incubated > this.period_symptoms) && !this.symptoms && !this.flag_symptoms) {
      if (flip(this.prob_symptoms)) {
        this.set_symptoms();
      }
      this.flag_symptoms = true;
    }
  }

  void update_retired() {
    if (this.symptoms && (ts - this.ts_symptoms > this.period_retire) && !this.retired && !this.flag_retired) {
      if (flip(this.prob_retire)) {
        this.set_retired();
      }
      this.flag_retired = true;
    }
  }

  void update_reported() {
    if (this.symptoms && (ts - this.ts_symptoms > this.period_report) && !this.reported && !this.flag_reported) {
      if (flip(this.prob_report)) {
        this.set_reported();
      }
      this.flag_reported = true;
    }
  }

  void update_alerted() {
    if (this.alerted && !this.retired && !this.flag_alerted) {
      this.set_quarantined();
      this.flag_alerted = true;
    }
  }

  void update_outdoors() {
    if ((this.retired || this.quarantined) && !this.symptoms && this.cell_home == null) {
      this.cell_home_id = grid_home.put();
      this.cell_home = grid_home.get_cell(this.cell_home_id);
      if (this.cell_hospital != null) {
        grid_hospital.free(this.cell_hospital_id);
        this.cell_hospital = null;
      }
    } else if ((this.retired || this.quarantined) && this.symptoms && this.cell_hospital == null) {
      this.cell_hospital_id = grid_hospital.put();
      this.cell_hospital = grid_hospital.get_cell(this.cell_hospital_id);
      if (this.cell_home != null) {
        grid_home.free(this.cell_home_id);
        this.cell_home = null;
      }
    }
  }

  void update_quarantine() {
    if (this.quarantined && !this.symptoms && this.cell_home != null && (ts - this.ts_quarantined > this.period_quarantine)) {
      this.init();
      this.flag_quarantined = true;
      grid_home.free(this.cell_home_id);
    }
  }


  void update() {
    this.update_incubated();
    this.update_symptoms();
    this.update_retired();
    this.update_reported();
    this.update_alerted();
    this.update_outdoors();
    this.update_quarantine();
  }
}
