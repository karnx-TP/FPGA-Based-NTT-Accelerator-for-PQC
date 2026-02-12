##
quit -sim
vlib work

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vlog -cover bcse -work work ../../ntt/mont_inv_transform.sv
#--------------------------------#
#--     Compile Package        --#
#--------------------------------#

#--------------------------------#
#--   	Compile Test Bench     --#
#--------------------------------#
vlog -work work tb_mont.sv

vsim -t 100ps -novopt work.tb_mont

view wave

do wave.do

view structure
view signals

run -all