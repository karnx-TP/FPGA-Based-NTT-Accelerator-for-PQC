module tb_mont ();
	
	integer TM = 0;
	integer TT = 0;

	localparam BITLEN = 13;
	localparam CLK_PERIOD = 10;

	//wire
	logic clk;
	logic rstB;
	logic [(2*BITLEN)-1:0]		wA;
	logic [BITLEN-1:0]			wM;
	logic [BITLEN-1:0]			wM_inv;
	logic [BITLEN-1:0]			wRES;
	logic wStart;
	logic wResEn;

	mont_InvTF_unit mont_inv_inst(
		.clk(clk),
		.rstB(rstB),
		.a(wA), //Positive only
		.m(wM),
		.m_inv(wM_inv),

		.start(wStart),
		.result(wRES),
		.resultEn(wResEn)
	);

	always begin
		clk = 1'b0;
		#(CLK_PERIOD/2);
		clk = 1'b1;
		#(CLK_PERIOD/2);
	end

	initial begin
		rstB = 1'b0;
		wA = 0; //7680*7680
		wM = 0;
		wM_inv = 0; //-modInverse(7681,8192) mod 8192 = 7679
		wStart = 1'b0;
		#(2*CLK_PERIOD);
		rstB = 1'b1;
		#(CLK_PERIOD);
		wA = 1464; //7680*7680
		wM = 7681;
		wM_inv = 7679; //-modInverse(7681,8192) mod 8192 = 7679
		wStart = 1'b1;
		#(CLK_PERIOD);
		wStart = 1'b0;
		while(wResEn != 1'b1)begin
			#(CLK_PERIOD);
		end
		$display("Result = ",wRES);
		#10;
		$stop();
	end

endmodule