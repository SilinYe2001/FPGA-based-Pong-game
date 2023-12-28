
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -group game_tb
add wave -noupdate -group game_tb -radix decimal /game_tb/*

add wave -noupdate -group game_tb/uut_start_signal
add wave -noupdate -group game_tb/start_signal -radix hexadecimal /game_tb/uut_start_signal/*

add wave -noupdate -group game_tb/uut_tank1
add wave -noupdate -group game_tb/uut_tank1 -radix decimal /game_tb/uut_tank1/*

add wave -noupdate -group game_tb/uut_tank2
add wave -noupdate -group game_tb/uut_tank2 -radix decimal /game_tb/uut_tank2/*

add wave -noupdate -group game_tb/uut_bullet1
add wave -noupdate -group game_tb/uut_bullet1 -radix decimal /game_tb/uut_bullet1/*

add wave -noupdate -group game_tb/uut_bullet2
add wave -noupdate -group game_tb/uut_bullet2 -radix decimal /game_tb/uut_bullet2/*



WaveRestoreCursors {{Cursor 1} {0 ns} 0}
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 250
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
update
WaveRestoreZoom {0 ns} {1 us}
