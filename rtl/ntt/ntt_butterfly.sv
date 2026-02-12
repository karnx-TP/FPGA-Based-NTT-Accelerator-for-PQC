//----------------------------------------
// File : ntt_butterfly.sv
// Author : Thitipong Pav
// Description:Non-pipeline NTT Computation Unit with multiple Butterfly unit
//			   Output = NTT(A) ; 
//			   W = twiddle factor, Q = Modulus, Q_inv = ModInv(Q,2^13)
//----------------------------------------



module ntt_butterfly #(
	parameter DATA_WIDTH = 13,
	parameter ADDR_WIDTH = 10,
	parameter POLY_LEN = 256,
	parameter BF_UNIT = 8,
	parameter N_INV_M = 512
) (
	input logic 								clk,
	input logic 								rstB,
	input logic 								start,
	input logic									mode_sel, //0=NTT, 1=INTT
	input logic [ADDR_WIDTH-1:0]				startAddrA,
	input logic [ADDR_WIDTH-1:0]				startAddrW,
	input logic [ADDR_WIDTH-1:0]				offsetIntt_W,

	output logic[ADDR_WIDTH-1:0]				ramAddr_A,
	input logic [DATA_WIDTH:0]					ramDataOut_A,
	output logic[DATA_WIDTH-1:0]				ramDataWr_A,
	output logic								ramWrEn_A,

	output logic[ADDR_WIDTH-1:0]				ramAddr_W,
	input logic[DATA_WIDTH-1:0]					ramDataOut_W,

	input logic[DATA_WIDTH-1:0]			dataQ,
	input logic[DATA_WIDTH-1:0]			dataQ_inv,

	output logic						finish
);
//Parameter
	localparam BFST_CNT = $clog2(POLY_LEN);
	localparam OP_PER_STAGE = POLY_LEN/(2*BF_UNIT);
	genvar i;

//Signal 
	//Const Signal (Receive once)
	logic						rMode;
	logic[DATA_WIDTH-1:0]		rDataQ;
	logic[DATA_WIDTH-1:0]		rDataQ_inv;
	//RD_DATA
	logic						rReadDataStart;
	logic[ADDR_WIDTH-1:0]		rStartAddrA;
	logic[ADDR_WIDTH-1:0]		rStartAddrW;
	logic[BFST_CNT:0]			rDataRdCnt; //0->(N-1)
	logic[BFST_CNT-1:0]			wBR_DataRdCnt;
	logic[BFST_CNT:0]			rDataRdCnt1; //0->(N-1)
	
	logic signed [DATA_WIDTH:0]		rA [0:POLY_LEN-1];
	logic[DATA_WIDTH-1:0]				rW [0:POLY_LEN-1];

	//Butterfly Unit Wire
	logic signed [DATA_WIDTH:0]		wBfuA [0:BF_UNIT-1];
	logic signed [DATA_WIDTH:0]		wBfuB [0:BF_UNIT-1];
	logic [DATA_WIDTH-1:0]			wBfuW [0:BF_UNIT-1];
	logic signed [DATA_WIDTH:0]		rBfuA [0:BF_UNIT-1];
	logic signed [DATA_WIDTH:0]		rBfuB [0:BF_UNIT-1];
	logic [DATA_WIDTH-1:0]			rBfuW [0:BF_UNIT-1];

	logic [DATA_WIDTH-1:0]			wBfuQ;
	logic [DATA_WIDTH-1:0]			wBfuQ_inv;
	logic						wBfuMode;
	logic [DATA_WIDTH-1:0]			wRES1 [0:BF_UNIT-1];
	logic [DATA_WIDTH-1:0]			wRES2 [0:BF_UNIT-1];
	logic 						wResEn[0:BF_UNIT-1];

	//ST_BF Signal
	logic[$clog2(OP_PER_STAGE):0]		rOpCnt;
	logic[$clog2(BFST_CNT):0]			rStageCnt, rStageCnt1, wIdxIntt;
	logic [$clog2(POLY_LEN)-1:0] 		wStride, wDistance, wDistance_INTT;
	logic[BFST_CNT-1:0]					rOpAddr;
	logic								rStartButterflyOp;
	logic								rStartButterflyOp1;
	logic								wBFOutEn;

	//BF MUX Decoder
	logic [$clog2(POLY_LEN)-1:0] base [0:BF_UNIT-1];
	logic [$clog2(POLY_LEN)-1:0] offset_i [0:BF_UNIT-1];
	logic [$clog2(POLY_LEN)-1:0] offset [0:BF_UNIT-1];
	logic [$clog2(POLY_LEN)-1:0] scale_addr[0:BF_UNIT-1];

	//ST_WB
	logic [BFST_CNT-1:0] 				rWrCnt;
	logic								rOutEn;

	//ST_SCALE
	localparam SCALE_CNT = POLY_LEN/BF_UNIT;
	logic[$clog2(SCALE_CNT):0]			rScaleCnt;
	logic								rDirectMulMod;
	logic								rDirectMulMod1;


//FSM
	typedef enum logic [2:0] {
        STIDLE, ST_RD_DATA, ST_BF, ST_SCALE,ST_WB
    } state_t;
	state_t		rState_current;
	state_t		wState_next;

	always @(posedge clk ) begin
		if(!rstB)begin
			rState_current <= STIDLE;
		end else begin
			rState_current <= wState_next;
		end
	end

	always_comb begin : FSM
		case (rState_current)
			STIDLE : begin
				if(start)begin
					wState_next = ST_RD_DATA;
				end else begin
					wState_next = rState_current;
				end
			end
			ST_RD_DATA : begin
				if(rDataRdCnt[BFST_CNT])begin
					wState_next = ST_BF;
				end else begin
					wState_next = rState_current;
				end
			end
			ST_BF : begin
				if(wResEn[0] && (rStageCnt == BFST_CNT - 1)) begin
					if(!rMode)begin
						wState_next = ST_WB;
					end else begin
						wState_next = ST_SCALE;
					end
				end else begin
					wState_next = rState_current;
				end
			end
			ST_SCALE : begin
				if(wResEn[0] && (rScaleCnt == SCALE_CNT - 1))begin
					wState_next = ST_WB;
				end else begin
					wState_next = rState_current;
				end
			end
			ST_WB : begin
				if(rWrCnt == POLY_LEN-1)begin
					wState_next = STIDLE;
				end else begin
					wState_next = rState_current;
				end
			end
			default: wState_next = STIDLE;
		endcase
	end


//Process
	//MARK: IDLE->RD_DATA
	always @(posedge clk) begin
		if(start)begin
			rStartAddrA <= startAddrA;
			rStartAddrW <= (!mode_sel) ? startAddrW : startAddrW+offsetIntt_W;
			rMode <= mode_sel;
			rDataQ <= dataQ;
			rDataQ_inv <= dataQ_inv;
		end
	end
	always @(posedge clk ) begin
		if(start)begin
			rReadDataStart <= 1'b1;
		end else begin
			rReadDataStart <= 1'b0;
		end
	end

	//MARK: RD_DATA
	always @(posedge clk ) begin
		if(rState_current == STIDLE)begin
			rDataRdCnt <= 0;
		end else if (rState_current == ST_RD_DATA) begin
			rDataRdCnt <= rDataRdCnt + 1;
		end else begin
			rDataRdCnt <= 0;
		end

		rDataRdCnt1 <= rDataRdCnt;
	end

	assign ramAddr_W = rStartAddrW + rDataRdCnt;
	always @(posedge clk ) begin
		rW[rDataRdCnt1] <= ramDataOut_W;
	end

	generate
		for(i = 0;i<POLY_LEN;i=i+1)begin
			assign wBR_DataRdCnt[i] = rDataRdCnt[BFST_CNT-i-1]; //Bit reversal Addr
		end
	endgenerate
	
	assign ramAddr_A = (rState_current == ST_WB) ?  rStartAddrA + rWrCnt :
													rStartAddrA + wBR_DataRdCnt;
	always @(posedge clk ) begin
		if(rState_current == ST_RD_DATA)begin
			rA[rDataRdCnt1] <= $signed(ramDataOut_A);
		end else if((rState_current == ST_BF && wResEn[0]) || (rState_current == ST_SCALE))begin
			for (int i = 0; i < BF_UNIT; i++) begin
				if(rState_current == ST_BF)begin
					rA[base[i] + offset[i]] <= {1'b0,wRES1[i]};
					rA[base[i] + offset[i] + wDistance] <= {1'b0,wRES2[i]};
				end else if(rState_current == ST_SCALE && wResEn[0])begin
					rA[scale_addr[i]] <= {1'b0,wRES1[i]};
				end
			end
		end
	end
	//MARK: Butterfly
	always @(posedge clk ) begin
		if(rState_current == ST_RD_DATA)begin
			rOpCnt <= 0;
		end else if(wResEn[0] && rOpCnt != OP_PER_STAGE-1)begin
			rOpCnt <= rOpCnt + 1;
		end
	end

	
	always @(posedge clk ) begin
		if(rState_current == ST_RD_DATA && wState_next == ST_BF)begin
			rStartButterflyOp <= 1'b1;
		end else if(wResEn[0] && (rStageCnt != BFST_CNT - 1) && rState_current == ST_BF)begin
			rStartButterflyOp <= 1'b1;
		end else begin
			rStartButterflyOp <= 1'b0;
		end
	end
	
	always @(posedge clk ) begin
		if(rState_current == ST_RD_DATA)begin
			rStageCnt <= 0;
			rStageCnt1 <= 1;
		end else if(wResEn[0] && rOpCnt == OP_PER_STAGE-1)begin
			rStageCnt <= rStageCnt + 1;
			rStageCnt1 <= rStageCnt1 + 1;
		end
	end
	
	//BF Decoder
	always @(posedge clk ) begin
		for (int i = 0; i < BF_UNIT; i++) begin
			if(rState_current == ST_RD_DATA)begin
				base[i] <= i << 1; 
				offset[i] <= i % 1; // Num group
				offset_i[i] <= i;
			end else if(wResEn[0] && rOpCnt == OP_PER_STAGE-1)begin
				base[i] <= (i >> rStageCnt1) << (rStageCnt1 + 1); 
				offset[i] <= i % (1 << rStageCnt1); // Num group
				offset_i[i] <= (i >> rStageCnt1);
			end

			if(wState_next == ST_SCALE && rState_current != ST_SCALE)begin
				scale_addr[i] <= i;
			end else if(rState_current == ST_SCALE && wResEn[0]) begin
				scale_addr[i] <= i + ((rScaleCnt+1) << 3);
			end
		end
		
	end


	//BF Const Input
	assign wBfuQ = rDataQ;
	assign wBfuQ_inv = rDataQ_inv;
	assign wBfuMode = rMode;

	// BF Input MUX
	assign wDistance = 1 << rStageCnt; // 1, 2, 4, 8
	assign wIdxIntt = (BFST_CNT - 1 - rStageCnt);
	assign wDistance_INTT = 1 << wIdxIntt;

	always_comb begin
		for (int i = 0; i < BF_UNIT; i++) begin
			wBfuW[i] = (!rMode) ? rW[wDistance + offset[i]] : rW[wDistance_INTT + offset_i[i]];

			if(rState_current == ST_BF)begin
				wBfuA[i] = rA[base[i] + offset[i]];
				wBfuB[i] = rA[base[i] + offset[i] + wDistance];
			end else if(rState_current == ST_SCALE) begin
				wBfuA[i] = rA[scale_addr[i]];
				wBfuB[i] = N_INV_M;
			end else begin
				wBfuA[i] = 0;
				wBfuB[i] = 0;
			end
			
		end
	end

	always @(posedge clk ) begin
		rBfuA <= wBfuA;
		rBfuB <= wBfuB;
		rBfuW <= wBfuW;
		rStartButterflyOp1 <= rStartButterflyOp;
		rDirectMulMod1 <= rDirectMulMod;
	end

	generate
		for(i = 0;i < BF_UNIT;i = i+1)begin
			butterfly_unit u_bf_unit (
				.clk(clk),
				.rstB(rstB),
				.start(rStartButterflyOp1),

				.a(rBfuA[i]), //Can be Negative
				.b(rBfuB[i]),
				.w(rBfuW[i]),
				.q(wBfuQ),
				.q_invr(wBfuQ_inv),
				.mode(wBfuMode),	// 0 = NTT, 1 = INTT

				.out1(wRES1[i]),
				.out2(wRES2[i]),
				.outEn(wResEn[i]),
				.directMulMod(rDirectMulMod1)
			);
		end
	endgenerate


	//Scale
	always @(posedge clk ) begin
		rDirectMulMod = (wState_next == ST_SCALE && rState_current != ST_SCALE) || (rState_current == ST_SCALE && wResEn[0]);
		
		if(wState_next == ST_SCALE && rState_current != ST_SCALE)begin
			rScaleCnt <= 0;
		end else if(rState_current == ST_SCALE && wResEn[0]) begin
			rScaleCnt <= rScaleCnt + 1;
		end
	end
	
	//WB
	always @(posedge clk ) begin
		if(!rstB)begin
			ramWrEn_A <= 1'b0;
		end	else if((rState_current == ST_WB && wState_next != STIDLE) || (wState_next == ST_WB))begin
			ramWrEn_A <= 1'b1;
		end else begin
			ramWrEn_A <= 1'b0;
		end
	end

	always @(posedge clk ) begin
		if(rState_current == ST_WB)begin
			rWrCnt <= rWrCnt + 1;
		end else begin
			rWrCnt <= 0;
		end
	end

	assign ramDataWr_A = rA[rWrCnt];

	always @(posedge clk ) begin
		if(rWrCnt == POLY_LEN-1)begin
			rOutEn <= 1'b1;
		end else begin
			rOutEn <= 1'b0;
		end
	end

	assign finish = rOutEn;

endmodule