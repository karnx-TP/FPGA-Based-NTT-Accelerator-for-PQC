onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ntt/TM
add wave -noupdate /tb_ntt/TT
add wave -noupdate /tb_ntt/clk
add wave -noupdate /tb_ntt/rstB
add wave -noupdate -expand -group {WR RAM A} /tb_ntt/wTbWrEn
add wave -noupdate -expand -group {WR RAM A} -radix unsigned /tb_ntt/wTbAddr
add wave -noupdate -expand -group {WR RAM A} -radix unsigned /tb_ntt/wTbdataIn
add wave -noupdate -expand -group {WR RAM A} -radix unsigned /tb_ntt/wA
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/clk
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/enA
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/wrEnA
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/addrA
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/dataA
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/outA
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/enB
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/wrEnB
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/addrB
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/dataB
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/outB
add wave -noupdate -expand -group {RAM A} -radix unsigned /tb_ntt/ramA/ram
add wave -noupdate -expand -group NTT /tb_ntt/uNTT/clk
add wave -noupdate -expand -group NTT /tb_ntt/uNTT/rstB
add wave -noupdate -expand -group NTT /tb_ntt/uNTT/start
add wave -noupdate -expand -group NTT -group IO /tb_ntt/uNTT/mode_sel
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/dataQ
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/dataQ_inv
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/rMode
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/offsetIntt_W
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/startAddrA
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/rStartAddrA
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/startAddrW
add wave -noupdate -expand -group NTT -group IO -radix unsigned /tb_ntt/uNTT/rStartAddrW
add wave -noupdate -expand -group NTT /tb_ntt/uNTT/wState_next
add wave -noupdate -expand -group NTT /tb_ntt/uNTT/rState_current
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/ramAddr_W
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/rDataQ
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/rDataQ_inv
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/rReadDataStart
add wave -noupdate -expand -group NTT -radix unsigned -childformat {{{/tb_ntt/uNTT/rDataRdCnt[4]} -radix unsigned} {{/tb_ntt/uNTT/rDataRdCnt[3]} -radix unsigned} {{/tb_ntt/uNTT/rDataRdCnt[2]} -radix unsigned} {{/tb_ntt/uNTT/rDataRdCnt[1]} -radix unsigned} {{/tb_ntt/uNTT/rDataRdCnt[0]} -radix unsigned}} -subitemconfig {{/tb_ntt/uNTT/rDataRdCnt[4]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rDataRdCnt[3]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rDataRdCnt[2]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rDataRdCnt[1]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rDataRdCnt[0]} {-height 15 -radix unsigned}} /tb_ntt/uNTT/rDataRdCnt
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/rDataRdCnt1
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/ramAddr_A
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/ramDataOut_A
add wave -noupdate -expand -group NTT -radix unsigned -childformat {{{/tb_ntt/uNTT/rA[0]} -radix unsigned} {{/tb_ntt/uNTT/rA[1]} -radix unsigned} {{/tb_ntt/uNTT/rA[2]} -radix unsigned} {{/tb_ntt/uNTT/rA[3]} -radix unsigned} {{/tb_ntt/uNTT/rA[4]} -radix unsigned} {{/tb_ntt/uNTT/rA[5]} -radix unsigned} {{/tb_ntt/uNTT/rA[6]} -radix unsigned} {{/tb_ntt/uNTT/rA[7]} -radix unsigned} {{/tb_ntt/uNTT/rA[8]} -radix unsigned} {{/tb_ntt/uNTT/rA[9]} -radix unsigned} {{/tb_ntt/uNTT/rA[10]} -radix unsigned} {{/tb_ntt/uNTT/rA[11]} -radix unsigned} {{/tb_ntt/uNTT/rA[12]} -radix unsigned} {{/tb_ntt/uNTT/rA[13]} -radix unsigned} {{/tb_ntt/uNTT/rA[14]} -radix unsigned} {{/tb_ntt/uNTT/rA[15]} -radix unsigned}} -subitemconfig {{/tb_ntt/uNTT/rA[0]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[1]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[2]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[3]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[4]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[5]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[6]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[7]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[8]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[9]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[10]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[11]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[12]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[13]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[14]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rA[15]} {-height 15 -radix unsigned}} /tb_ntt/uNTT/rA
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/ramDataOut_W
add wave -noupdate -expand -group NTT -radix unsigned -childformat {{{/tb_ntt/uNTT/rW[0]} -radix unsigned} {{/tb_ntt/uNTT/rW[1]} -radix unsigned} {{/tb_ntt/uNTT/rW[2]} -radix unsigned} {{/tb_ntt/uNTT/rW[3]} -radix unsigned} {{/tb_ntt/uNTT/rW[4]} -radix unsigned} {{/tb_ntt/uNTT/rW[5]} -radix unsigned} {{/tb_ntt/uNTT/rW[6]} -radix unsigned} {{/tb_ntt/uNTT/rW[7]} -radix unsigned} {{/tb_ntt/uNTT/rW[8]} -radix unsigned} {{/tb_ntt/uNTT/rW[9]} -radix unsigned} {{/tb_ntt/uNTT/rW[10]} -radix unsigned} {{/tb_ntt/uNTT/rW[11]} -radix unsigned} {{/tb_ntt/uNTT/rW[12]} -radix unsigned} {{/tb_ntt/uNTT/rW[13]} -radix unsigned} {{/tb_ntt/uNTT/rW[14]} -radix unsigned} {{/tb_ntt/uNTT/rW[15]} -radix unsigned}} -subitemconfig {{/tb_ntt/uNTT/rW[0]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[1]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[2]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[3]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[4]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[5]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[6]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[7]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[8]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[9]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[10]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[11]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[12]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[13]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[14]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/rW[15]} {-height 15 -radix unsigned}} /tb_ntt/uNTT/rW
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/rOpCnt
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/rStartButterflyOp
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/ramWrEn_A
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/ramDataWr_A
add wave -noupdate -expand -group NTT /tb_ntt/uNTT/rDirectMulMod
add wave -noupdate -expand -group NTT -radix unsigned /tb_ntt/uNTT/wBFOutEn
add wave -noupdate /tb_ntt/uNTT/finish
add wave -noupdate -expand -group {BF state} /tb_ntt/uNTT/rStartButterflyOp
add wave -noupdate -expand -group {BF state} /tb_ntt/uNTT/rScaleCnt
add wave -noupdate -expand -group {BF state} /tb_ntt/uNTT/wState_next
add wave -noupdate -expand -group {BF state} /tb_ntt/uNTT/rState_current
add wave -noupdate -expand -group {BF state} /tb_ntt/uNTT/rA
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/rW
add wave -noupdate -expand -group {BF state} /tb_ntt/uNTT/wBfuA
add wave -noupdate -expand -group {BF state} /tb_ntt/uNTT/wBfuB
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wBfuW
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wBfuQ
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wBfuQ_inv
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wBfuMode
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wRES1
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wRES2
add wave -noupdate -expand -group {BF state} -radix unsigned {/tb_ntt/uNTT/wResEn[0]}
add wave -noupdate -expand -group {BF state} -radix unsigned -childformat {{{/tb_ntt/uNTT/wResEn[0]} -radix unsigned} {{/tb_ntt/uNTT/wResEn[1]} -radix unsigned} {{/tb_ntt/uNTT/wResEn[2]} -radix unsigned} {{/tb_ntt/uNTT/wResEn[3]} -radix unsigned} {{/tb_ntt/uNTT/wResEn[4]} -radix unsigned} {{/tb_ntt/uNTT/wResEn[5]} -radix unsigned} {{/tb_ntt/uNTT/wResEn[6]} -radix unsigned} {{/tb_ntt/uNTT/wResEn[7]} -radix unsigned}} -subitemconfig {{/tb_ntt/uNTT/wResEn[0]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/wResEn[1]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/wResEn[2]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/wResEn[3]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/wResEn[4]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/wResEn[5]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/wResEn[6]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/wResEn[7]} {-height 15 -radix unsigned}} /tb_ntt/uNTT/wResEn
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/rOpCnt
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/rStageCnt
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wStride
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wDistance
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/rOpAddr
add wave -noupdate -expand -group {BF state} -radix unsigned /tb_ntt/uNTT/wBFOutEn
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/clk}
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rstB}
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/start}
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/a}
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/b}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/w}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/q}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/q_invr}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mode}
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rDirectMulMod}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/out1}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/out2}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/outEn}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rA_mod_q}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rB_mod_q}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rW}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rQ}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rQ_invr}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rMode}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rAdd_sub}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wMulInput0}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wMulInput1}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rMulResult}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rMul1En}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rMontStart}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wMulModResult}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rMulModResult}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wMultModEn}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wAddInput0}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wAddInput1}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wAddResult}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wSubResult}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wAddResultminusQ}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wAddResultModQ}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rAddResultModQ}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wSubResultminusQ}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wSubResultModQ}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rSubResultModQ}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/result_ntt}
add wave -noupdate -expand -group BF_0 -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/result_inv_ntt}
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/rState_current}
add wave -noupdate -expand -group BF_0 {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/wState_next}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/clk}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rstB}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/a}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/m}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/m_inv}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/start}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/result}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/resultEn}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/mulIn1}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/mulIn2_mont}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/directMulMod}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rStart}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/wAmodR}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/wMul1}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/wMul2}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rX}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/wXmodR}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rXM}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/wR1}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/wR1divR}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/wR1subM}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rResult}
add wave -noupdate -expand -group MONT -radix unsigned -childformat {{{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[25]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[24]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[23]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[22]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[21]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[20]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[19]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[18]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[17]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[16]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[15]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[14]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[13]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[12]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[11]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[10]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[9]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[8]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[7]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[6]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[5]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[4]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[3]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[2]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[1]} -radix unsigned} {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[0]} -radix unsigned}} -subitemconfig {{/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[25]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[24]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[23]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[22]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[21]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[20]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[19]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[18]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[17]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[16]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[15]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[14]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[13]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[12]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[11]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[10]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[9]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[8]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[7]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[6]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[5]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[4]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[3]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[2]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[1]} {-height 15 -radix unsigned} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes[0]} {-height 15 -radix unsigned}} {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulModRes}
add wave -noupdate -expand -group MONT -radix unsigned {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulMod1}
add wave -noupdate {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulMod2}
add wave -noupdate {/tb_ntt/uNTT/genblk2[0]/u_bf_unit/mont_inv_inst/rDirectMulMod3}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {169400 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 429
configure wave -valuecolwidth 76
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
WaveRestoreZoom {129400 ps} {209400 ps}
