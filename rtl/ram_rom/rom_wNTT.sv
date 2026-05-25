module rom_ntt
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
		rom[1] = 7193;
		rom[2] = 5363;
		rom[3] = 7174;
		rom[4] = 7219;
		rom[5] = 307;
		rom[6] = 3703;
		rom[7] = 6035;
		rom[8] = 6736;
		rom[9] = 6431;
		rom[10] = 5865;
		rom[11] = 4588;
		rom[12] = 1639;
		rom[13] = 4200;
		rom[14] = 6409;
		rom[15] = 2097;
		rom[16] = 7329;
		rom[17] = 3071;
		rom[18] = 1160;
		rom[19] = 2274;
		rom[20] = 3160;
		rom[21] = 7519;
		rom[22] = 1457;
		rom[23] = 883;
		rom[24] = 261;
		rom[25] = 3200;
		rom[26] = 711;
		rom[27] = 3420;
		rom[28] = 1672;
		rom[29] = 2695;
		rom[30] = 2171;
		rom[31] = 720;
		rom[32] = 1703;
		rom[33] = 1277;
		rom[34] = 6636;
		rom[35] = 795;
		rom[36] = 1196;
		rom[37] = 2949;
		rom[38] = 5364;
		rom[39] = 3490;
		rom[40] = 7231;
		rom[41] = 5120;
		rom[42] = 7461;
		rom[43] = 4210;
		rom[44] = 6720;
		rom[45] = 5472;
		rom[46] = 725;
		rom[47] = 1139;
		rom[48] = 7182;
		rom[49] = 4312;
		rom[50] = 1975;
		rom[51] = 6546;
		rom[52] = 1819;
		rom[53] = 1152;
		rom[54] = 3791;
		rom[55] = 6708;
		rom[56] = 1512;
		rom[57] = 7376;
		rom[58] = 6884;
		rom[59] = 5825;
		rom[60] = 2000;
		rom[61] = 7115;
		rom[62] = 5245;
		rom[63] = 2625;
	end

endmodule
