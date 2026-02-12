onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/clk
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rstB
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/start
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rState_current
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wState_next
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/a
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/b
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/w
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/q
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/q_invr
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/mode
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/add_sub
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rA_mod_q
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rB_mod_q
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rW
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rQ
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rQ_invr
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rMode
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rAdd_sub
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wMulInput0
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wMulInput1
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rMulResult
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rMul1En
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rMontStart
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wMulModResult
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rMulModResult
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wMultModEn
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wAddInput0
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wAddInput1
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wAddResult
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wAddResultminusQ
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/wAddResultModQ
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/rAddResultModQ
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/result_ntt
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/result_inv_ntt
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/out
add wave -noupdate -radix unsigned /tb_bntt/bntt_inst/outEn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6400 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
configure wave -valuecolwidth 81
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {24600 ps}
