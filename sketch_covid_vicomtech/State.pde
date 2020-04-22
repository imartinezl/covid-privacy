float n_healthy, n_infected, n_incubated, n_symptoms, n_quarantined, n_retired, n_total;
class State {

  long ts_infection, ts_incubated, ts_symptoms, ts_reported, ts_retired, ts_alerted, ts_quarantined;
  boolean infected, incubated, symptoms, reported, retired, alerted, quarantined;
  PVector cell_home, cell_hospital;
  int cell_home_id, cell_hospital_id;

  float period_incubation, period_symptoms, period_report, period_retire, period_quarantine;  
  float prob_symptoms, prob_retire, prob_report;
  boolean flag_symptoms, flag_retired, flag_reported, flag_alerted, flag_quarantined = false;

  State() {
    init();
  }

  void init() {
    this.init_params();

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

  void init_params() {
    this.prob_symptoms = gui.prob_symptoms; // probability of having symptoms after being infected
    this.prob_retire = gui.prob_retire; // probability of a symptomatic person to retire to their home
    this.prob_report = gui.prob_report; // probability of a symptomatic person to report their status

    this.period_incubation = gui.period_incubation*24*60;
    this.period_symptoms = gui.period_symptoms*24*60;
    this.period_report = gui.period_report*24*60;
    this.period_retire = gui.period_retire*24*60;
    this.period_quarantine = gui.period_quarantine*24*60;
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
    if ( this.infected && (ts - this.ts_infection > this.period_incubation/gui.tunit) && !this.incubated) {
      this.set_incubated();
    }
  }

  void update_symptoms() {
    if (this.incubated && (ts - this.ts_incubated > this.period_symptoms/gui.tunit) && !this.symptoms && !this.flag_symptoms) {
      if (flip(this.prob_symptoms)) {
        this.set_symptoms();
      }
      this.flag_symptoms = true;
    }
  }

  void update_retired() {
    if (this.symptoms && (ts - this.ts_symptoms > this.period_retire/gui.tunit) && !this.retired && !this.flag_retired) {
      if (flip(this.prob_retire)) {
        this.set_retired();
      }
      this.flag_retired = true;
    }
  }

  void update_reported() {
    if (this.symptoms && (ts - this.ts_symptoms > this.period_report/gui.tunit) && !this.reported && !this.flag_reported) {
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
    if (this.quarantined && !this.symptoms && this.cell_home != null && (ts - this.ts_quarantined > this.period_quarantine/gui.tunit)) {
      this.init();
      this.flag_quarantined = true;
      grid_home.free(this.cell_home_id);
    }
  }

  void update_count() {
    if (retired) n_retired++;
    else if (quarantined) n_quarantined++;
    else if (symptoms) n_symptoms++;
    else if (incubated) n_incubated++;
    else if (infected) n_infected++;
    else n_healthy++;
  }


  void update() {
    this.init_params();
    this.update_incubated();
    this.update_symptoms();
    this.update_retired();
    this.update_reported();
    this.update_alerted();
    this.update_outdoors();
    this.update_quarantine();
    this.update_count();
  }
}
