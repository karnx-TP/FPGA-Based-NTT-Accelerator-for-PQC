//----------------------------------------
// File : mont_inv_transform.sv
// Author : Thitipong Pav
// Desc : 13-bits montgomery Inverse Transform unit
//		  Convert Montgomery domain into normal domain = monPro(a,1)
//----------------------------------------


module mont_InvTF_unit #(
	parameter BITLEN = 13
) (
	input logic clk,
	input logic rstB,
	
	input logic [(2*BITLEN)-1:0]	a, //Positive only
	input logic [BITLEN-1:0]	m,
	input logic [BITLEN-1:0]	m_inv,

	input logic start,

	output logic [BITLEN-1:0]	result,
	output logic	resultEn,

	//Direct MUL
	input logic[BITLEN-1:0] mulIn1,
	input logic[BITLEN-1:0] mulIn2_mont,
	input logic directMulMod
);

//Signal
	logic[2:0]					rStart;
	logic[BITLEN-1:0]			wAmodR;
	logic[(2*BITLEN)-1:0]		wMul1;
	logic[(2*BITLEN)-1:0]		wMul2;
	logic[(2*BITLEN)-1:0]		rX;
	logic[BITLEN-1:0]			wXmodR;
	logic[(2*BITLEN)-1:0]		rXM;
	logic[(2*BITLEN):0]			wR1;
	logic[BITLEN:0]				wR1divR;
	logic[BITLEN:0]				wR1subM;
	logic[BITLEN-1:0]			rResult;

	logic[(2*BITLEN)-1:0]		rDirectMulModRes;
	logic						rDirectMulMod1;
	logic						rDirectMulMod2;
	logic rDirectMulMod3;

//Simple State Machine
	always @(posedge clk ) begin
		if(!rstB)begin
			rStart <= 3'b000;
		end else begin
			rStart[0] <= start || rDirectMulMod1;
			rStart[1] <= rStart[0];
			rStart[2] <= rStart[1];
		end
	end

//Data Path	
	//start->0
	assign wAmodR = (rDirectMulMod1) ? rDirectMulModRes[BITLEN-1:0] : a[BITLEN-1:0];
	assign wMul1 = (directMulMod) ? mulIn1*mulIn2_mont : m_inv*wAmodR;
	always @(posedge clk) begin
		if(directMulMod)begin
			rDirectMulModRes <= wMul1;
		end
		
		rDirectMulMod1 <= directMulMod;
		rDirectMulMod2 <= rDirectMulMod1;
		rDirectMulMod3 <= rDirectMulMod2;

		rX <= wMul1;
	end
	
	//0->1
	assign wXmodR = rX[BITLEN-1:0];
	assign wMul2 = wXmodR*m;
	always @(posedge clk ) begin
		rXM <= wMul2;
	end

	//1->2
	assign wR1 = (rDirectMulMod3) ? rXM + rDirectMulModRes: rXM + a;
	assign wR1divR = wR1[(2*BITLEN):BITLEN];
	assign wR1subM = wR1divR - m;
	always @(posedge clk )  begin
		if(wR1subM[BITLEN])begin // r1<m
			rResult <= wR1divR;
		end else begin
			rResult <= wR1subM[BITLEN-1:0];
		end
	end

	assign result = rResult;
	assign resultEn = rStart[2];

	

	
endmodule