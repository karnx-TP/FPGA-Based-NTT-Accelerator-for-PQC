onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ntt_top/TM
add wave -noupdate /tb_ntt_top/TT
add wave -noupdate /tb_ntt_top/uNTT_top/clk
add wave -noupdate /tb_ntt_top/uNTT_top/rstB
add wave -noupdate /tb_ntt_top/uNTT_top/UserWrEn
add wave -noupdate -radix hexadecimal /tb_ntt_top/uNTT_top/UserWrAddr
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/UserWrDataIn
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/UserRdDataOut
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/start
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/mode
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rFinish
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rDataQ
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rDataQ_inv
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rStartAddrA
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rStartAddrW
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rOffsetIntt_W
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rUserRdDataOut
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/rUserWrAddr
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamUserWrEn
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamUserWrAddr
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamUserWrDataIn
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamUserDataOut
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamAddr_A
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamDataOut_A
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamDataWr_A
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamWrEn_A
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamAddr_W
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wRamDataOut_W
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wFinish
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wDataOut_wNTT
add wave -noupdate -radix unsigned /tb_ntt_top/uNTT_top/wDataOut_wINTT
add wave -noupdate -radix unsigned -childformat {{{/tb_ntt_top/uNTT_top/ramA/ram[0]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[1]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[2]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[3]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[4]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[5]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[6]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[7]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[8]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[9]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[10]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[11]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[12]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[13]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[14]} -radix unsigned} {{/tb_ntt_top/uNTT_top/ramA/ram[15]} -radix unsigned}} -expand -subitemconfig {{/tb_ntt_top/uNTT_top/ramA/ram[0]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[1]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[2]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[3]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[4]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[5]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[6]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[7]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[8]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[9]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[10]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[11]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[12]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[13]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[14]} {-radix unsigned} {/tb_ntt_top/uNTT_top/ramA/ram[15]} {-radix unsigned}} /tb_ntt_top/uNTT_top/ramA/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 265
configure wave -valuecolwidth 86
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
WaveRestoreZoom {0 ps} {188800 ps}
