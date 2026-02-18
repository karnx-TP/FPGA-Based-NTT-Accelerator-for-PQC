module tb_ntt_top ();
	
	integer TM = 0;
	integer TT = 0;

	localparam NTT_CR = 11'h410;
	localparam NTT_STADDRA = 11'h411;
	localparam NTT_STADDRW = 11'h412;
	localparam NTT_OSW = 11'h413;
	localparam NTT_DATAQ = 11'h414;
	localparam NTT_DATAQINV = 11'h415;
	localparam NTT_RAMA_WRITE = 11'h500;

	localparam BITLEN = 13;
	localparam CLK_PERIOD = 10;
	localparam DATA_WIDTH = BITLEN;
	localparam ADDR_WIDTH = 11;
	localparam POLY_LEN = 64;
	localparam N_INV_M = 128;
	localparam BF_UNIT = 8;
	localparam RAM_WORD_LEN = 16;

	//wire
	logic 								clk;
	logic 								rstB;

	logic								wTbWrEn;
	logic[ADDR_WIDTH-1:0]				wTbAddr;
	logic[RAM_WORD_LEN-1:0]				wTbdataIn;
	logic[RAM_WORD_LEN-1:0]				wTbdataOut;

	//Test Signal
	logic[BITLEN:0]		wA [0:POLY_LEN-1];
	logic[BITLEN:0]		wNTT_A_exp [0:POLY_LEN-1];
	int wrong_cnt = 0;
	logic wFinish = 1'b0;


NTT_top #(
	.NTT_CR(NTT_CR),
	.NTT_STADDRA(NTT_STADDRA),
	.NTT_STADDRW(NTT_STADDRW),
	.NTT_OSW(NTT_OSW),
	.NTT_DATAQ(NTT_DATAQ),
	.NTT_DATAQINV(NTT_DATAQINV),
	.NTT_RAMA_WRITE(NTT_RAMA_WRITE),

	.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.POLY_LEN(POLY_LEN),
	.N_INV_M(N_INV_M),
	.BF_UNIT(BF_UNIT),
	.RAM_WORD_LEN(RAM_WORD_LEN)

) uNTT_top (
	.clk(clk),
	.rstB(rstB),

	//RAM A User Write
	.UserWrEn(wTbWrEn),
	.UserWrAddr(wTbAddr),
	.UserWrDataIn(wTbdataIn),
	.UserRdDataOut(wTbdataOut)
);


	task writeRAM_A(
		logic [BITLEN:0]		A [0:POLY_LEN-1],
		logic [ADDR_WIDTH-1:0]		startAddrA
	);
		begin
			//Write Start Addr
			wTbWrEn = 1'b1;
			wTbdataIn = {{(RAM_WORD_LEN-ADDR_WIDTH){1'b0}},startAddrA};
			wTbAddr = NTT_STADDRA;
			#(CLK_PERIOD);

			//Burst Write
			wTbWrEn = 1'b1;
			for(int i = 0; i < POLY_LEN; i++) begin
				wTbdataIn = A[i];
				wTbAddr = NTT_RAMA_WRITE + startAddrA + i;
				
				#(CLK_PERIOD);
			end
			wTbWrEn = 1'b0;
		end
	endtask

	task startNTT(
		logic [ADDR_WIDTH-1:0]		startAddrA,
		logic [ADDR_WIDTH-1:0]		startAddrW,
		logic [ADDR_WIDTH-1:0]		offsetIntt_W,
		logic [ADDR_WIDTH-1:0]		mode,
		logic[DATA_WIDTH-1:0]			Q,
		logic[DATA_WIDTH-1:0]			Q_inv
	);
		begin
			wTbWrEn = 1'b1;
			wTbAddr = NTT_STADDRA;
			wTbdataIn = {{(RAM_WORD_LEN-ADDR_WIDTH){1'b0}},startAddrA};
			#(CLK_PERIOD);
			wTbAddr = NTT_STADDRW;
			wTbdataIn = {{(RAM_WORD_LEN-ADDR_WIDTH){1'b0}},startAddrW};
			#(CLK_PERIOD);
			wTbAddr = NTT_OSW;
			wTbdataIn = {{(RAM_WORD_LEN-ADDR_WIDTH){1'b0}},offsetIntt_W};
			#(CLK_PERIOD);
			wTbAddr = NTT_DATAQ;
			wTbdataIn = Q;
			#(CLK_PERIOD);
			wTbAddr = NTT_DATAQINV;
			wTbdataIn = Q_inv;
			#(CLK_PERIOD);
			wTbAddr = NTT_CR;
			wTbdataIn = {{(RAM_WORD_LEN-3){1'b0}},1'b0,mode,1'b1};
			#(CLK_PERIOD);
			wTbWrEn = 1'b0;
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
		wTbWrEn = 1'b0;
		#(2*CLK_PERIOD);
		rstB = 1'b1;
		#(CLK_PERIOD);

		$display("TM:1, Write Data to RAM A");
		TM = 1;
		for(int i=0; i<POLY_LEN; i++) begin
			wA[i] = i+1;
		end
		writeRAM_A(wA, 0);
		#(CLK_PERIOD);

		$display("TM:2, NTT");
		TM=2;
		startNTT(0,0,0,0,7681,7679);
		while(wFinish != 1'b1)begin
			wTbAddr = NTT_CR;
			#(CLK_PERIOD);
			wFinish = wTbdataOut[2];
		end
		wFinish = 0;
		wNTT_A_exp = {4144,4272,1005,5282,1588,6160,3113,1629,5155,6159,5057,932,3990,3531,2097,5811,5244,295,2188,7103,2310,6839,1752,4531,5915,4249,4568,4590,3480,2635,2943,5906,3664,6781,5377,1466,4793,6626,2538,3685,3682,6494,3679,384,7604,7022,209,1532,3685,540,3832,6327,6031,3318,5873,4943,6088,2927,6449,4253,1150,2785,2942,2385};
		for(int i=0;i<POLY_LEN;i++)begin
			if(wNTT_A_exp[i] !=uNTT_top.ramA.ram[0+i])begin
				wrong_cnt += 1;
				$display("Wrong @",i);
				break;
			end
			if(i == POLY_LEN-1)begin
				$display("Correct");
			end
		end 

		//Try INTT
		$display("TM:3, INTT");
		TM=3;
		startNTT(0,0,0,1,7681,7679);
		while(wFinish != 1'b1)begin
			wTbAddr = NTT_CR;
			#(CLK_PERIOD);
			wFinish = wTbdataOut[2];
		end
		for(int i=0;i<POLY_LEN;i++)begin
			if(wA[i] != uNTT_top.ramA.ram[0+i])begin
				wrong_cnt += 1;
				$display("Wrong @",i);
				break;
			end
			if(i == POLY_LEN-1)begin
				$display("Correct");
			end
		end 
		


		#(3*CLK_PERIOD);
		$display("Testbench End.");
		$display("Wrong Cnt = ",wrong_cnt);
		$stop();
	end

endmodule