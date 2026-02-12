module tb_bntt ();
	
	integer TM = 0;
	integer TT = 0;

	localparam BITLEN = 13;
	localparam CLK_PERIOD = 10;

	//wire
	logic clk;
	logic rstB;
	logic wStart;
	logic wResEn;
	logic signed [BITLEN:0]		wA;
	logic signed [BITLEN:0]		wB;
	logic [BITLEN-1:0]			wW;
	logic [BITLEN-1:0]			wQ;
	logic [BITLEN-1:0]			wQ_inv;
	logic						wMode;
	logic						wAddSub;
	logic [BITLEN-1:0]		wRES;
	logic [BITLEN-1:0]		wRES_SUB;

	int wrong_cnt = 0;

	butterfly_unit bntt_inst(
		.clk(clk),
		.rstB(rstB),
		.start(wStart),

		.a(wA), //Can be Negative
		.b(wB),
		.w(wW),
		.q(wQ),
		.q_invr(wQ_inv),
		.mode(wMode),	// 0 = NTT, 1 = INTT

		.outAdd(wRES),
		.outSub(wRES_SUB),
		.outEn(wResEn)
	);

	task butterfly_a_b(
		logic signed [BITLEN:0]		A,
		logic signed [BITLEN:0]		B,
		logic [BITLEN-1:0]			W,
		logic [BITLEN-1:0]			Q,
		logic [BITLEN-1:0]			Q_inv,
		logic						Mode,
		logic[BITLEN-1:0]			Exp_output,
		logic[BITLEN-1:0]			Exp_output_Sub
	);
	begin
		wA = A; 
		wB = B;
		wW = W;
		wQ = Q;
		wQ_inv = Q_inv; 
		wMode = Mode; 
		wStart = 1'b1;
		#(CLK_PERIOD);
		wStart = 1'b0;
		while(wResEn != 1'b1)begin
			#(CLK_PERIOD);
		end
		if(wRES == Exp_output && wRES_SUB == Exp_output_Sub)begin
			$display("Result Correct = ",wRES,wRES_SUB);
		end else begin
			$display("Wrong = %0d (Exp=%0d)--------------------------------",wRES,Exp_output);
			$display("Wrong = %0d (Exp=%0d)--------------------------------",wRES_SUB,Exp_output_Sub);
			$display("Input :",A,B,W,Q,Q_inv,Mode);
			wrong_cnt += 1;
		end
		#(2*CLK_PERIOD);
	end
		
	endtask

	always begin
		clk = 1'b0;
		#(CLK_PERIOD/2);
		clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	initial begin
		TM = 0;
		TT = 0;
		rstB = 1'b0;
		wA = 0; 
		wB = 0;
		wW = 0;
		wQ = 0;
		wQ_inv = 0; //-modInverse(7681,8192) mod 8192 = 7679
		wStart = 1'b0;
		#(2*CLK_PERIOD);
		rstB = 1'b1;
		#(CLK_PERIOD);

		$display("TM:1, Test NTT Add");
		TM = 1;
		butterfly_a_b(0,2,488,7681,7679,0,6766,915);
		butterfly_a_b(-3,3,488,7681,7679,0,2465,5210);
		butterfly_a_b(6766,2465,507,7681,7679,0,5033,818);

		$display("TM:2, Test INTT t0");
		TM = 2;
		butterfly_a_b(3366,4526,5363,7681,7679,1,211,6224);
		butterfly_a_b(6224,1481,7193,7681,7679,1,24,40);

		$display("Testbench End.");
		$display("Wrong Cnt = ",wrong_cnt);
		$stop();
	end

endmodule