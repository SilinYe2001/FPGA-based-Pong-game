setenv LMC_TIMEUNIT -9
vlib work
vmap work work


vcom -2008 -work work "start_signal_sim.vhd"
vcom -2008 -work work "tank1.vhd"
vcom -2008 -work work "tank2.vhd"
vcom -2008 -work work "Bullet1.vhd"
vcom -2008 -work work "Bullet2.vhd"
vcom -2008 -work work "game_tb.vhd"



vsim +notimingchecks -L work work.game_tb -wlf wave.wlf

do wave.do

run -all

--quit