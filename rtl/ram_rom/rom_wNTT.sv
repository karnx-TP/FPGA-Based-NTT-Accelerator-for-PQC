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
		rom[1] = 488;
		rom[2] = 7174;
		rom[3] = 5363;
		rom[4] = 7374;
		rom[5] = 7219;
		rom[6] = 6035;
		rom[7] = 3978;
		rom[8] = 3481;
		rom[9] = 945;
		rom[10] = 4588;
		rom[11] = 1272;
		rom[12] = 1250;
		rom[13] = 1639;
		rom[14] = 5584;
		rom[15] = 1816;
		rom[16] = 2695;
		rom[17] = 261;
		rom[18] = 2274;
		rom[19] = 5510;
		rom[20] = 4481;
		rom[21] = 4521;
		rom[22] = 720;
		rom[23] = 711;
		rom[24] = 7519;
		rom[25] = 7329;
		rom[26] = 4261;
		rom[27] = 6224;
		rom[28] = 4610;
		rom[29] = 1672;
		rom[30] = 883;
		rom[31] = 1160;
	end

endmodule
