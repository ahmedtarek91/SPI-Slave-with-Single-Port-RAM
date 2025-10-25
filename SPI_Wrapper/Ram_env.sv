package Ram_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_agent_pkg::*;
    import Ram_scoreboard_pkg::*;
    import Ram_coverage_pkg::*;

    class Ram_env extends uvm_env;
        `uvm_component_utils(Ram_env)

        Ram_agent agent;
        Ram_scoreboard scoreboard;
        Ram_coverage coverage;

        function new(string name = "Ram_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agent       = Ram_agent::type_id::create("agent", this);
            scoreboard  = Ram_scoreboard::type_id::create("scoreboard", this);
            coverage    = Ram_coverage::type_id::create("coverage", this);
        endfunction : build_phase

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agent_ap.connect(scoreboard.sb_export);
            agent.agent_ap.connect(coverage.cov_export);
        endfunction : connect_phase
    endclass: Ram_env
endpackage