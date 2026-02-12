//----------------------------------------
// File : butterfly_unit.sv
// Author : Thitipong Pav
// Desc : Flexible Butterfly Unit for NTT Butterfly Operation 
//		  with Modular Multiplier
//----------------------------------------

module butterfly_unit #(
	parameter DATA_WIDTH = 13 //7681~13 bit 
) (
	input logic clk,
	input logic rstB,

	input logic start,

	input logic signed [DATA_WIDTH:0] a, //Can be Negative
	input logic signed [DATA_WIDTH:0] b,
	input logic [DATA_WIDTH-1:0] w, // twiddle factor
	input logic [DATA_WIDTH-1:0] q,  // Prime
	input logic [DATA_WIDTH-1:0] q_invr,  // Prime inv r
	input logic mode,	// 0 = NTT, 1 = INTT

	output logic [DATA_WIDTH-1:0] out1,
	output logic [DATA_WIDTH-1:0] out2,
	output logic outEn,

	//Direct MUL
	input logic directMulMod
);

//Signal
	logic [DATA_WIDTH-1:0]		rA_mod_q;
	logic [DATA_WIDTH-1:0]		rB_mod_q;
	logic [DATA_WIDTH-1:0] 		rW; // twiddle factor
	logic [DATA_WIDTH-1:0] 		rQ;  // Prime
	logic [DATA_WIDTH-1:0] 		rQ_invr;  // Prime inv r
	logic rMode;
	logic rAdd_sub;

	logic [DATA_WIDTH-1:0]		wMulInput0;
	logic [DATA_WIDTH-1:0]		wMulInput1;
	logic [(2*DATA_WIDTH)-1:0]		rMulResult;
	logic						rMul1En;
	logic						rMontStart;
	logic [DATA_WIDTH-1:0]		wMulModResult;
	logic [DATA_WIDTH-1:0]		rMulModResult;
	logic						wMultModEn;

	logic [DATA_WIDTH-1:0]		wAddInput0;
	logic [DATA_WIDTH-1:0]		wAddInput1;
	logic [DATA_WIDTH:0]		wAddResult;
	logic [DATA_WIDTH:0]		wSubResult;
	logic [DATA_WIDTH:0]		wAddResultminusQ;
	logic [DATA_WIDTH-1:0]		wAddResultModQ;
	logic [DATA_WIDTH-1:0]		rAddResultModQ;
	logic [DATA_WIDTH:0]		wSubResultminusQ;
	logic [DATA_WIDTH-1:0]		wSubResultModQ;
	logic [DATA_WIDTH-1:0]		rSubResultModQ;

	logic [DATA_WIDTH-1:0]		result_ntt;
	logic [DATA_WIDTH-1:0]		result_inv_ntt;

	logic [DATA_WIDTH-1:0] rOutAdd;
	logic [DATA_WIDTH-1:0] rOutSub;

	//directMulMod
	logic rDirectMulMod;

//FSM
	typedef enum logic [3:0] {
        STIDLE, ST_NTT_MUL0,ST_NTT_MUL1, ST_NTT_ADD_SUB, ST_NTT_OUT,
				ST_INTT_ADD_SUB, ST_INTT_MUL0, ST_INTT_MUL1, ST_INTT_OUT
    } state_t;
	state_t		rState_current;
	state_t		wState_next;

	always @(posedge clk) begin
		if(!rstB)begin
			rState_current <= STIDLE;
		end else begin
			rState_current <= wState_next;
		end
		
	end

	always_comb begin : FSM_Comb
		case (rState_current)
			STIDLE : begin
				if(start && (!directMulMod))begin
					wState_next <= (!mode) ? ST_NTT_MUL0 : ST_INTT_ADD_SUB;
				end else begin
					wState_next <= rState_current;
				end
			end
			ST_NTT_MUL0 : begin
				wState_next <= ST_NTT_MUL1; 
			end
			ST_NTT_MUL1 : begin
				if(wMultModEn)begin
					wState_next <= ST_NTT_ADD_SUB;
				end else begin
					wState_next <= rState_current;
				end
			end
			ST_NTT_ADD_SUB : begin
				wState_next <= ST_NTT_OUT;
			end
			ST_NTT_OUT : begin
				wState_next <= STIDLE;
			end

			ST_INTT_ADD_SUB : begin
				wState_next <= ST_INTT_MUL0;
			end
			ST_INTT_MUL0 : begin
				wState_next <= ST_INTT_MUL1;
			end
			ST_INTT_MUL1 : begin
				if(wMultModEn)begin
					wState_next <= ST_INTT_OUT;
				end else begin
					wState_next <= rState_current;
				end
			end
			ST_INTT_OUT : begin
				wState_next <= STIDLE;
			end

			default: wState_next <= STIDLE;
		endcase
	end
	

//Data Path
	// Input Reg
	always @(posedge clk) begin
		if(rState_current == STIDLE)begin
			rA_mod_q <= a[DATA_WIDTH] ? (a + q) : a[DATA_WIDTH-1:0];
			rB_mod_q <= b[DATA_WIDTH] ? (b + q) : b[DATA_WIDTH-1:0];
			rW <= w;
			rQ <= q;
			rQ_invr <= q_invr;
			rMode <= mode;
		end
	end

	//MUL0
	assign wMulInput0 = (!rMode) ? rB_mod_q :
						rSubResultModQ;
	assign wMulInput1 = rW;
	always @(posedge clk) begin
		rMulResult <= wMulInput0*wMulInput1;

		if(!rstB)begin
			rMul1En <= 1'b0;
		end else if((rState_current == ST_NTT_MUL0) || (rState_current == ST_INTT_MUL0))begin
			rMul1En <= 1'b1;
		end else begin
			rMul1En <= 1'b0;
		end
	end
	always @(posedge clk ) begin
		if(!rstB)begin
			rMontStart <= 1'b0;
		end else if(rMul1En)begin
			rMontStart <= 1'b1;
		end else begin
			rMontStart <= 1'b0;
		end
	end

	//MUL1
	mont_InvTF_unit mont_inv_inst(
		.clk(clk),
		.rstB(rstB),

		.a(rMulResult), //Positive only
		.m(q),
		.m_inv(q_invr),
		
		.start(rMontStart),
		.result(wMulModResult),
		.resultEn(wMultModEn),

		.mulIn1(a[DATA_WIDTH-1:0]),
		.mulIn2_mont(b[DATA_WIDTH-1:0]),
		.directMulMod(directMulMod)
	);
	always @(posedge clk ) begin
		if(wMultModEn)begin
			rMulModResult <= wMulModResult;
		end
	end
	
	//Add_Sub
	assign wAddInput0 = rA_mod_q;
	assign wAddInput1 = (!rMode) ? rMulModResult :
						rB_mod_q;
	//Add
	assign wAddResult = wAddInput0 + wAddInput1;
	assign wAddResultminusQ = wAddResult - q;
	always_comb begin : add_proc
		if(wAddResult[DATA_WIDTH] & rAdd_sub)begin
			wAddResultModQ = wAddResult + q;
		end else if(wAddResultminusQ[DATA_WIDTH])begin
			wAddResultModQ = wAddResult[DATA_WIDTH-1:0];
		end else begin
			wAddResultModQ = wAddResultminusQ[DATA_WIDTH-1:0];
		end
	end

	//Sub
	assign wSubResult =	wAddInput0 - wAddInput1;
	assign wSubResultminusQ = wSubResult - q;
	always_comb begin : sub_proc
		if(wSubResult[DATA_WIDTH])begin
			wSubResultModQ = wSubResult + q;
		end else if(wSubResultminusQ[DATA_WIDTH])begin
			wSubResultModQ = wSubResult[DATA_WIDTH-1:0];
		end else begin
			wSubResultModQ = wSubResultminusQ[DATA_WIDTH-1:0];
		end
	end

	always @(posedge clk ) begin
		if(rState_current == ST_INTT_ADD_SUB)begin
			rAddResultModQ <= wAddResultModQ;
			rSubResultModQ <= wSubResultModQ;
		end
	end

//directMulMod
	always @(posedge clk ) begin
		if(!rstB)begin
			rDirectMulMod <= 1'b0;
		end else if(directMulMod) begin
			rDirectMulMod <= 1'b1;
		end else if(outEn)begin
			rDirectMulMod <= 1'b0;
		end 
	end

//Output
	assign out1 = (rDirectMulMod) ? rMulModResult : rOutAdd;
	assign out2 = rOutSub;
	always @(posedge clk ) begin
		if(rState_current == ST_NTT_ADD_SUB) begin
			rOutAdd <= wAddResultModQ;
			rOutSub <= wSubResultModQ;
		end else if(rState_current == ST_INTT_MUL1 && wMultModEn == 1'b1) begin
			rOutAdd <= rAddResultModQ;
			rOutSub <= wMulModResult;
		end else begin
			rOutAdd <= {DATA_WIDTH{1'b1}};
			rOutSub <= {DATA_WIDTH{1'b1}};
		end
			
	end

	always @(posedge clk ) begin
		if(!rstB)begin
			outEn <= 1'b0;
		end else if(rState_current == ST_NTT_ADD_SUB || (rState_current == ST_INTT_MUL1 && wMultModEn == 1'b1) || (wMultModEn && rDirectMulMod))begin
			outEn <= 1'b1;
		end else begin
			outEn <= 1'b0;
		end
	end
	

endmodule