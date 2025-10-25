package Wrapper_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_agent_pkg::*;
    import Wrapper_scoreboard_pkg::*;
    import Wrapper_coverage_pkg::*;

    class Wrapper_env extends uvm_env;
        `uvm_component_utils(Wrapper_env)

        Wrapper_agent agent;
        Wrapper_scoreboard scoreboard;
        Wrapper_coverage coverage;

        function new(string name = "Wrapper_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agent       = Wrapper_agent::type_id::create("agent", this);
            scoreboard  = Wrapper_scoreboard::type_id::create("scoreboard", this);
            coverage    = Wrapper_coverage::type_id::create("coverage", this);
        endfunction : build_phase

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agent_ap.connect(scoreboard.sb_export);
            agent.agent_ap.connect(coverage.cov_export);
        endfunction : connect_phase
    endclass: Wrapper_env
endpackage