onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/sif/clk
add wave -noupdate /top/sif/rst_n
add wave -noupdate -color Gold /top/sif/SS_n
add wave -noupdate -color Maroon /top/sif/cs
add wave -noupdate -radix unsigned /top/DUT/counter
add wave -noupdate -radix binary /top/sif/array_for_MOSI
add wave -noupdate /top/sif/MOSI
add wave -noupdate -color Magenta /top/sif/rx_valid
add wave -noupdate -color Plum -radix binary /top/sif/rx_data
add wave -noupdate -color Turquoise /top/sif/tx_valid
add wave -noupdate -color Turquoise -radix binary /top/sif/tx_data
add wave -noupdate /top/sif/MISO
add wave -noupdate /top/DUT/received_address
add wave -noupdate -color {Light Steel Blue} /top/sif/rx_valid_ref
add wave -noupdate -color {Light Steel Blue} /top/sif/cs_ref
add wave -noupdate -color {Light Steel Blue} -radix binary /top/sif/rx_data_ref
add wave -noupdate -color {Light Steel Blue} /top/sif/MISO_ref
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {155279 ns} 0}
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
WaveRestoreZoom {156316 ns} {156594 ns}
