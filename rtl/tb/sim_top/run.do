##
quit -sim
vlib work

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vlog -cover bcse -work work ../../ntt/*.sv
vlog -cover bcse -work work ../../ram_rom/*.sv

#--------------------------------#
#--     Compile Package        --#
#--------------------------------#

#--------------------------------#
#--   	Compile Test Bench     --#
#--------------------------------#
vlog -work work tb_ntt_top.sv

vsim -t 100ps -novopt work.tb_ntt_top

view wave

do wave.do

view structure
view signals

run -all