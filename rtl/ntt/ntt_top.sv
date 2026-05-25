//----------------------------------------
// File : ntt_top.sv
// Author : Thitipong Pav
// Desc : Top Module of NTT Transformer with User DataBus Interface 
//----------------------------------------


module NTT_top #(
	parameter NTT_CR = 11'h410,
	parameter NTT_STADDRA = 11'h411,
	parameter NTT_STADDRW = 11'h412,
	parameter NTT_OSW = 11'h413,
	parameter NTT_DATAQ = 11'h414,
	parameter NTT_DATAQINV = 11'h415,
	parameter NTT_SIG = 11'h416,
	parameter NTT_RAMA_WRITE = 11'h500,

	parameter DATA_WIDTH = 13,
	parameter ADDR_WIDTH = 11,
	parameter POLY_LEN = 64,
	parameter N_INV_M = 128,
	parameter BF_UNIT = 8,
	parameter RAM_WORD_LEN = 16
) (
	input logic clk,
	input logic rstB,

	//RAM A User Write
	input logic								UserWrEn,
	input logic[ADDR_WIDTH-1:0]				UserWrAddr,
	input logic[RAM_WORD_LEN-1:0]				UserWrDataIn,
	output logic[RAM_WORD_LEN-1:0]				UserRdDataOut
);

	localparam SIGNATURE = 13'h489;

//Reg
	logic start;
	logic mode;
	logic rFinish;
	logic[DATA_WIDTH-1:0]					rDataQ;
	logic[DATA_WIDTH-1:0]					rDataQ_inv;
	logic [ADDR_WIDTH-1:0]				rStartAddrA;
	logic [ADDR_WIDTH-1:0]				rStartAddrW;
	logic [ADDR_WIDTH-1:0]				rOffsetIntt_W;
	logic[RAM_WORD_LEN-1:0]				rUserRdDataOut;
	logic[ADDR_WIDTH-1:0]				rUserWrAddr;

//RAM A user write
	logic								wRamUserWrEn;
	logic[ADDR_WIDTH-4:0]				wRamUserWrAddr;
	logic[RAM_WORD_LEN-1:0]				wRamUserWrDataIn;
	logic[RAM_WORD_LEN-1:0]				wRamUserDataOut;

//RAM A <--> NTT I/F
	logic[ADDR_WIDTH-1:0]				wRamAddr_A;
	logic[RAM_WORD_LEN-1:0]				wRamDataOut_A;
	logic[DATA_WIDTH-1:0]				wRamDataWr_A;
	logic								wRamWrEn_A;

//ROM W <--> NTT I/F
	logic[ADDR_WIDTH-1:0]				wRamAddr_W;
	logic[DATA_WIDTH-1:0]				wRamDataOut_W;

//Signal
	logic wFinish;
	logic[RAM_WORD_LEN-1:0] 						wDataOut_wNTT;
	logic[RAM_WORD_LEN-1:0] 						wDataOut_wINTT;

//Reg Access
	assign UserRdDataOut = (rUserWrAddr[ADDR_WIDTH-1:ADDR_WIDTH-3] == (NTT_RAMA_WRITE>>8)) ? wRamUserDataOut : rUserRdDataOut;
	always @(posedge clk ) begin
		rUserWrAddr <= UserWrAddr;

		case (UserWrAddr)
			NTT_CR : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-3){1'b0}},rFinish,mode,start};
			end
			NTT_STADDRA : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},rStartAddrA};
			end
			NTT_STADDRW : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},rStartAddrW};
			end
			NTT_OSW : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},rOffsetIntt_W};
			end
			NTT_DATAQ : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},rDataQ};
			end
			NTT_DATAQINV : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},rDataQ_inv};
			end
			NTT_RAMA_WRITE : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},rDataQ_inv};
			end
			NTT_SIG : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},SIGNATURE};
			end
			default : begin
				rUserRdDataOut <= {{(RAM_WORD_LEN-DATA_WIDTH){1'b0}},SIGNATURE};
			end
		endcase
	end
	
	always @(posedge clk ) begin
		if(UserWrEn)begin
			case (UserWrAddr)
				NTT_CR : begin
					mode <= UserWrDataIn[1];
				end
				NTT_STADDRA : begin
					rStartAddrA <= UserWrDataIn[DATA_WIDTH-1:0];
				end
				NTT_STADDRW : begin
					rStartAddrW <= UserWrDataIn[DATA_WIDTH-1:0];
				end
				NTT_OSW : begin
					rOffsetIntt_W <= UserWrDataIn[DATA_WIDTH-1:0];
				end
				NTT_DATAQ : begin
					rDataQ <= UserWrDataIn[DATA_WIDTH-1:0];
				end
				NTT_DATAQINV : begin
					rDataQ_inv <= UserWrDataIn[DATA_WIDTH-1:0];
				end
			endcase
		end 

		if(!rstB)begin
			start <= 1'b0;
		end else if(UserWrEn && UserWrAddr == NTT_CR)begin
			start <= UserWrDataIn[0];
		end else begin
			start <= 1'b0;
		end
		
		if(!rstB)begin
			rFinish <= 1'b0;
		end else if(wFinish)begin
			rFinish <= 1'b1;
		end else if(UserWrEn && UserWrAddr == NTT_CR)begin
			rFinish <= UserWrDataIn[2];
		end

	end

	ntt_butterfly  #(
		.POLY_LEN(POLY_LEN),
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.BF_UNIT(BF_UNIT),
		.N_INV_M(N_INV_M)
	) uNTT (
		.clk(clk),
		.rstB(rstB),
		.start(start),
		.mode_sel(mode), //0=NTT, 1=INTT
		.startAddrA(rStartAddrA),
		.startAddrW(rStartAddrW),
		.offsetIntt_W(rOffsetIntt_W),

		.ramAddr_A(wRamAddr_A),
		.ramDataOut_A(wRamDataOut_A[DATA_WIDTH:0]),
		.ramDataWr_A(wRamDataWr_A),
		.ramWrEn_A(wRamWrEn_A),

		.ramAddr_W(wRamAddr_W),
		.ramDataOut_W(wRamDataOut_W),

		.dataQ(rDataQ),
		.dataQ_inv(rDataQ_inv),

		.finish(wFinish)
	);

	assign wRamUserWrEn = UserWrEn && (UserWrAddr[ADDR_WIDTH-1:ADDR_WIDTH-3] == NTT_RAMA_WRITE[ADDR_WIDTH-1:ADDR_WIDTH-3]);
	assign wRamUserWrAddr = UserWrAddr[ADDR_WIDTH-4:0];
	assign wRamUserWrDataIn = UserWrDataIn;
	bram_dp_word  #(
		.DEPTH(256),
    	.XLEN(16)
	) ramA (
		.clk(clk),
		.enA(1'b1),
		.wrEnA(wRamWrEn_A),
		.addrA(wRamAddr_A[ADDR_WIDTH-4:0]),
		.dataA({3'b000,wRamDataWr_A}),
		.outA(wRamDataOut_A),

		.enB(1'b1),
		.wrEnB(wRamUserWrEn),
		.addrB(wRamUserWrAddr),
		.dataB(wRamUserWrDataIn),
		.outB(wRamUserDataOut)
	);

	assign wRamDataOut_W = (mode == 1'b0) ? wDataOut_wNTT[DATA_WIDTH-1:0] : wDataOut_wINTT[DATA_WIDTH-1:0];
	rom_ntt uROM_ntt (
		.clk(clk),
		.we(1'b0),
		.addr(wRamAddr_W),
		.din(8'h0),
		.dout(wDataOut_wNTT)
	);
	rom_intt uROM_intt (
		.clk(clk),
		.we(1'b0),
		.addr(wRamAddr_W),
		.din(8'h0),
		.dout(wDataOut_wINTT)
	);
	
endmodule