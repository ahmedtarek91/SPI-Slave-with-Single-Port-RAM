package Wrapper_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Wrapper_seq_item_pkg::*;

    class Wrapper_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(Wrapper_scoreboard)
        uvm_analysis_export #(Wrapper_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(Wrapper_seq_item) sb_fifo;
        Wrapper_seq_item seq_item_sb;

        int error_count =0; int correct_count=0;

        function new(string name = "Wrapper_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                if (seq_item_sb.MISO !== seq_item_sb.MISO_ref)
                begin
                    `uvm_error("run_phase", $sformatf("Mismatch: MISO=%0b, MISO_ref=%0b, %s",
                        seq_item_sb.MISO, seq_item_sb.MISO_ref,
                        seq_item_sb.convert2string_stimulus()))
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Match: MISO=%0b, MISO_ref=%0b",
                        seq_item_sb.MISO, seq_item_sb.MISO_ref), UVM_HIGH)
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total Correct: %0d, Total Errors: %0d", correct_count, error_count), UVM_MEDIUM)
        endfunction
    endclass: Wrapper_scoreboard
    
endpackage