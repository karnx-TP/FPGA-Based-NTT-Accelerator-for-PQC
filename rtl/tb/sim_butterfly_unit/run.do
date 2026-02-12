##
quit -sim
vlib work

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vlog -cover bcse -work work ../../ntt/mont_inv_transform.sv
vlog -cover bcse -work work ../../ntt/butterfly_unit.sv

#--------------------------------#
#--     Compile Package        --#
#--------------------------------#

#--------------------------------#
#--   	Compile Test Bench     --#
#--------------------------------#
vlog -work work tb_bntt.sv

vsim -t 100ps -novopt work.tb_bntt

view wave

do wave.do

view structure
view signals

run -all