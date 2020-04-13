class Contact {
  long ts;
  int agent_A, agent_B;
  float dist;

  Contact(long ts, int agent_A, int agent_B, float dist) {
    this.ts = ts;
    this.agent_A = agent_A;
    this.agent_B = agent_B;
    this.dist = dist;
  }

  void print_contact(PrintWriter output) {
    //output.println("ts,agent_A,agent_B,dist");
    output.print(this.ts);
    output.print(',');
    output.print(this.agent_A);
    output.print(',');
    output.print(this.agent_B);
    output.print(',');
    output.print(this.dist);
    output.println();
  }
}
