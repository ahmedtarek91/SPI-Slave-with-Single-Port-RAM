package Ram_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import Ram_seq_item_pkg::*;

    class Ram_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(Ram_scoreboard)
        uvm_analysis_export #(Ram_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(Ram_seq_item) sb_fifo;
        Ram_seq_item seq_item_sb;

        int error_count =0; int correct_count=0;

        function new(string name = "Ram_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export   = new("sb_export", this);
            sb_fifo     = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                if ((seq_item_sb.dout !== seq_item_sb.dout_ref) || (seq_item_sb.tx_valid !== seq_item_sb.tx_valid_ref))
                begin
                    if (seq_item_sb.dout !== seq_item_sb.dout_ref)
                        `uvm_error("run_phase", $sformatf("Dout Mismatch: dout=%0d, dout_ref=%0d, %s",
                            seq_item_sb.dout, seq_item_sb.dout_ref, seq_item_sb.convert2string_stimulus()))
                    else if (seq_item_sb.tx_valid !== seq_item_sb.tx_valid_ref)
                        `uvm_error("run_phase", $sformatf("Tx_valid Mismatch: tx_valid=%0b, tx_valid_ref=%0b, %s",
                            seq_item_sb.tx_valid, seq_item_sb.tx_valid_ref, seq_item_sb.convert2string_stimulus()))

                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Match: dout=%0d, tx_valid=%0b",
                        seq_item_sb.dout, seq_item_sb.tx_valid), UVM_HIGH)
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total Correct: %0d, Total Errors: %0d", correct_count, error_count), UVM_MEDIUM)
        endfunction
    endclass: Ram_scoreboard
    
endpackage