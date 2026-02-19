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
	localparam POLY_LEN = 256;
	localparam N_INV_M = 32;
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
		wNTT_A_exp = {4035,5326,1591,3793,231,2379,5189,6990,3768,6767,2392,5531,3443,6217,1699,310,4277,4576,5430,4897,5327,2716,6047,1029,4633,636,747,1948,2624,857,681,4229,7176,4503,196,2687,3235,1919,4932,5958,4852,3921,4730,2964,4691,1294,4128,7268,591,1722,4542,2041,6475,3520,2124,2851,2843,6146,3398,3864,7488,534,2743,6036,6238,5825,6887,1412,1549,327,3934,4573,7089,5243,7611,7290,1681,4023,3659,1272,265,5910,6968,7178,5713,6871,1912,4974,1024,1379,5585,4823,6155,6187,3312,6385,413,4168,2965,2984,6622,4328,6101,3944,6265,3175,4584,4561,7532,2253,7458,7353,4361,489,6562,2857,4186,5801,4979,4543,6057,3188,5534,2868,3092,898,1610,5446,4463,1378,2537,1229,299,4979,4505,2750,2807,1859,7426,161,6494,6655,7302,3299,1161,3824,7093,5371,4644,3667,4072,3851,1945,5037,235,6937,4645,6193,4528,3898,2629,416,2807,2171,7273,3191,373,1527,7071,1470,6401,4591,3087,4353,1410,3110,2025,1350,2050,2721,2086,6538,32,3815,2503,3577,2531,5638,7508,1755,7541,3050,2067,6303,4600,7341,7398,6114,6397,1005,7296,4193,5207,1682,234,4821,7223,472,5757,3897,3261,2841,3393,3172,5010,1227,7200,4311,272,2562,876,752,7104,298,2180,7409,3549,5488,5248,7125,2691,6795,6313,835,6449,83,3666,1106,4793,6208,6882,6448,298,1864,3269,1850,4809,2302,7038,7483,1544,2003,6018,5576,2567,649};
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