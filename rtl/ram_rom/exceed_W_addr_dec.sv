module exceed_W_addr_dec
	#(parameter MEM_SIZE = 2048)
    (clk, we, addr, din, dout);

	localparam ADDRW = $clog2(MEM_SIZE);
	localparam DEPTH = MEM_SIZE/4;

    input clk;
	input we;
	input [ADDRW-1:0] addr;
	input [7:0] din;
	output [15:0] dout;

	(* ram_style = "block" *) logic  [15:0] rom [0:DEPTH-1];
	logic [15:0] d_out;

	assign dout = rom[addr];

	initial begin
		//ROM
		rom[32] = 0;
		rom[160] = 0;
		rom[33] = 8;
		rom[161] = 0;
		rom[34] = 0;
		rom[162] = 1;
		rom[35] = 8;
		rom[163] = 1;
		rom[40] = 0;
		rom[168] = 0;
		rom[41] = 8;
		rom[169] = 0;
		rom[42] = 16;
		rom[170] = 0;
		rom[43] = 24;
		rom[171] = 0;
	end

endmodule
