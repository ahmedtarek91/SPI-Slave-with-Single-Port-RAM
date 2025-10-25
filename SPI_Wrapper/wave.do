onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/wif/clk
add wave -noupdate /top/wif/rst_n
add wave -noupdate -color Yellow /top/wif/SS_n
add wave -noupdate -color Sienna /top/wif/cs
add wave -noupdate -radix unsigned /top/DUT/SLAVE_instance/counter
add wave -noupdate -radix binary /top/wif/array_for_MOSI
add wave -noupdate /top/wif/MOSI
add wave -noupdate -color Magenta /top/sif/rx_valid
add wave -noupdate -color Plum -radix binary /top/sif/rx_data
add wave -noupdate -color Plum -radix binary /top/rif/din
add wave -noupdate -color White -radix binary /top/DUT/RAM_instance/Wr_Addr
add wave -noupdate -color White -radix binary /top/DUT/RAM_instance/Rd_Addr
add wave -noupdate -color Cyan /top/sif/tx_valid
add wave -noupdate -color Turquoise -radix binary /top/sif/tx_data
add wave -noupdate -color Turquoise -radix binary /top/rif/dout
add wave -noupdate /top/wif/MISO
add wave -noupdate /top/DUT/SLAVE_instance/received_address
add wave -noupdate -color Gray70 /top/wif/MISO_ref
add wave -noupdate -color Gray70 -radix binary /top/sif/rx_data_ref
add wave -noupdate -color Gray70 /top/sif/rx_valid_ref
add wave -noupdate -color Gray70 /top/rif/tx_valid_ref
add wave -noupdate -color Gray70 -radix binary /top/rif/dout_ref
add wave -noupdate /top/DUT/RAM_instance/MEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {458272 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {458247 ns} {458437 ns}
