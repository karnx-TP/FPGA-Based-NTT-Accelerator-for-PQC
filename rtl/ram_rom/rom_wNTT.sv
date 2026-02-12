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
		rom[4] = 462;
		rom[5] = 7374;
		rom[6] = 3978;
		rom[7] = 1646;
		rom[8] = 1639;
		rom[9] = 3481;
		rom[10] = 6409;
		rom[11] = 5584;
		rom[12] = 945;
		rom[13] = 6431;
		rom[14] = 1816;
		rom[15] = 4588;
	end

endmodule
