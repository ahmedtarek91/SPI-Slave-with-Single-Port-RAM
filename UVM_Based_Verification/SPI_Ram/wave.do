onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/rif/clk
add wave -noupdate /top/rif/rst_n
add wave -noupdate /top/rif/rx_valid
add wave -noupdate -color {Medium Blue} /top/rif/tx_valid
add wave -noupdate -color {Medium Blue} /top/rif/tx_valid_ref
add wave -noupdate -radix hexadecimal /top/rif/din
add wave -noupdate /top/DUT/Rd_Addr
add wave -noupdate /top/DUT/Wr_Addr
add wave -noupdate /top/rif/dout
add wave -noupdate /top/rif/dout_ref
add wave -noupdate /top/DUT/MEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13185 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 99
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {13136 ns} {13269 ns}
