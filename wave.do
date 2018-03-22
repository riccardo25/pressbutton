onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/CLK
add wave -noupdate /tb/rst_n
add wave -noupdate /tb/DATA
add wave -noupdate /tb/GO
add wave -noupdate /tb/done
add wave -noupdate /tb/count
add wave -noupdate /tb/int_count
add wave -noupdate /tb/DUT/DP/MUX1/I0
add wave -noupdate /tb/DUT/CTRL/state
add wave -noupdate /tb/DUT/DP/MUX3/sel
add wave -noupdate /tb/DUT/DP/ADDER1/Y
add wave -noupdate /tb/DUT/DP/MUX1/I0
add wave -noupdate /tb/DUT/DP/MUX1/sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {318 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {457 ns}
