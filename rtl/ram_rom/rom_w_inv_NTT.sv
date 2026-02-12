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
		rom[4] = 6035;
		rom[5] = 307;
		rom[6] = 3703;
		rom[7] = 7219;
		rom[8] = 3093;
		rom[9] = 2097;
		rom[10] = 1250;
		rom[11] = 4200;
		rom[12] = 5865;
		rom[13] = 1272;
		rom[14] = 6736;
		rom[15] = 6042;
	end

endmodule
