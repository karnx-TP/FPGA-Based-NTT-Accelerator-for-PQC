module rom_intt
	#(parameter MEM_SIZE = 2048)
    (clk, we, addr, din, dout);

	localparam ADDRW = $clog2(MEM_SIZE);
	localparam DEPTH = MEM_SIZE/4;

    input clk;
	input we;
	input [ADDRW-1:0] addr;
	input [7:0] din;
	output [15:0] dout;

	(* ram_style = "block" *) reg [15:0] rom [0:DEPTH-1];
	logic [15:0] d_out;

	assign dout = d_out;
	always @(posedge clk ) begin
		d_out <= rom[addr];
	end

	initial begin
		//ROM
		rom[0] = 511;
		rom[1] = 488;
		rom[2] = 507;
		rom[3] = 2318;
		rom[4] = 1646;
		rom[5] = 7374;
		rom[6] = 3978;
		rom[7] = 462;
		rom[8] = 5584;
		rom[9] = 3093;
		rom[10] = 3481;
		rom[11] = 1250;
		rom[12] = 1272;
		rom[13] = 1816;
		rom[14] = 6042;
		rom[15] = 945;
		rom[16] = 6961;
		rom[17] = 6798;
		rom[18] = 4261;
		rom[19] = 5407;
		rom[20] = 4986;
		rom[21] = 162;
		rom[22] = 4481;
		rom[23] = 4610;
		rom[24] = 5510;
		rom[25] = 6224;
		rom[26] = 6970;
		rom[27] = 6521;
		rom[28] = 6009;
		rom[29] = 4521;
		rom[30] = 7420;
		rom[31] = 352;
		rom[32] = 5056;
		rom[33] = 6542;
		rom[34] = 973;
		rom[35] = 4191;
		rom[36] = 1856;
		rom[37] = 3471;
		rom[38] = 1135;
		rom[39] = 6886;
		rom[40] = 566;
		rom[41] = 2209;
		rom[42] = 6529;
		rom[43] = 4732;
		rom[44] = 305;
		rom[45] = 2561;
		rom[46] = 3369;
		rom[47] = 6404;
		rom[48] = 2436;
		rom[49] = 6956;
		rom[50] = 3890;
		rom[51] = 2317;
		rom[52] = 797;
		rom[53] = 220;
		rom[54] = 5706;
		rom[55] = 1045;
		rom[56] = 5681;
		rom[57] = 961;
		rom[58] = 5862;
		rom[59] = 6485;
		rom[60] = 6169;
		rom[61] = 450;
		rom[62] = 499;
		rom[63] = 5978;
	end

endmodule
