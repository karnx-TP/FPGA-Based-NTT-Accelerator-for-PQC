module prog_rom_8bits
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
	end

endmodule
