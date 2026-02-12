module tb_ntt ();
	
	integer TM = 0;
	integer TT = 0;

	localparam BITLEN = 13;
	localparam CLK_PERIOD = 10;
	localparam DATA_WIDTH = BITLEN;
	localparam ADDR_WIDTH = 10;
	localparam POLY_LEN = 16;
	localparam BF_UNIT = 8;

	//wire
	logic 								clk;
	logic 								rstB;
	logic 								wStart;
	logic								wMode;
	logic [ADDR_WIDTH-1:0]				wStartAddrA;
	logic [ADDR_WIDTH-1:0]				wStartAddrW;
	logic [ADDR_WIDTH-1:0]				wOffsetIntt_W;

	logic[ADDR_WIDTH-1:0]				wRamAddr_A;
	logic[15:0]							wRamDataOut_A;
	logic[DATA_WIDTH-1:0]				wRamDataWr_A;
	logic								wRamWrEn_A;

	logic[ADDR_WIDTH-1:0]				wRamAddr_W;
	logic[DATA_WIDTH-1:0]				wRamDataOut_W;

	logic[DATA_WIDTH-1:0]				wDataQ;
	logic[DATA_WIDTH-1:0]				wDataQ_inv;

	logic 								wFinish;

	logic[15:0] 						wDataOut_wNTT;
	logic[15:0] 						wDataOut_wINTT;

	//RAM A Write
	logic								wTbWrEn;
	logic[ADDR_WIDTH-1:0]				wTbAddr;
	logic[15:0]							wTbdataIn;

	//Test Signal
	logic[BITLEN:0]		wA [0:POLY_LEN-1];
	logic[BITLEN:0]		wNTT_A_exp [0:POLY_LEN-1];



	int wrong_cnt = 0;

	ntt_butterfly  #(
		.POLY_LEN(POLY_LEN),
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.BF_UNIT(BF_UNIT)
	) uNTT (
		.clk(clk),
		.rstB(rstB),
		.start(wStart),
		.mode_sel(wMode), //0=NTT, 1=INTT
		.startAddrA(wStartAddrA),
		.startAddrW(wStartAddrW),
		.offsetIntt_W(wOffsetIntt_W),

		.ramAddr_A(wRamAddr_A),
		.ramDataOut_A(wRamDataOut_A[DATA_WIDTH:0]),
		.ramDataWr_A(wRamDataWr_A),
		.ramWrEn_A(wRamWrEn_A),

		.ramAddr_W(wRamAddr_W),
		.ramDataOut_W(wRamDataOut_W),

		.dataQ(wDataQ),
		.dataQ_inv(wDataQ_inv),

		.finish(wFinish)
	);

	
	bram_dp_word  #(
		.DEPTH(1024),
    	.XLEN(16)
	) ramA (
		.clk(clk),
		.enA(1'b1),
		.wrEnA(wRamWrEn_A),
		.addrA(wRamAddr_A),
		.dataA({3'b000,wRamDataWr_A}),
		.outA(wRamDataOut_A),

		.enB(1'b1),
		.wrEnB(wTbWrEn),
		.addrB(wTbAddr),
		.dataB(wTbdataIn),
		.outB()
	);

	assign wRamDataOut_W = (wMode == 1'b0) ? wDataOut_wNTT[DATA_WIDTH-1:0] : wDataOut_wINTT[DATA_WIDTH-1:0];
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

	task writeRAM_A(
		logic [BITLEN:0]		A [0:POLY_LEN-1],
		logic [ADDR_WIDTH-1:0]		startAddrA
	);
		begin
			//Burst Write
			wTbWrEn = 1'b1;
			for(int i = 0; i < POLY_LEN; i++) begin
				wTbdataIn = A[i];
				wTbAddr = startAddrA + i;
				
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
			wStartAddrA = startAddrA;
			wStartAddrW = startAddrW;
			wOffsetIntt_W = offsetIntt_W;
			wMode = mode;
			wDataQ = Q;
			wDataQ_inv = Q_inv;
			wStart = 1'b1;
			#(CLK_PERIOD)
			wStart = 1'b0;
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
		wStart = 1'b0;
		wMode = 1'b0;
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
		startNTT(0,0,0,0,7681,7679);
		while(wFinish != 1'b1)begin
			#(CLK_PERIOD);
		end
		wNTT_A_exp = {5669,6399,310,4357,2106,907,6987,3237,1920,3364,4670,5883,68,5121,3537,6929};
		for(int i=0;i<POLY_LEN;i++)begin
			if(wNTT_A_exp[i] != ramA.ram[0+i])begin
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
		startNTT(0,0,0,1,7681,7679);
		while(wFinish != 1'b1)begin
			#(CLK_PERIOD);
		end
		for(int i=0;i<POLY_LEN;i++)begin
			if(wA[i] != ramA.ram[0+i])begin
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