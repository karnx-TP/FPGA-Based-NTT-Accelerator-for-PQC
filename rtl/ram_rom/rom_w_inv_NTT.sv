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
		rom[1] = 7193;
		rom[2] = 2318;
		rom[3] = 507;
		rom[4] = 3703;
		rom[5] = 462;
		rom[6] = 1646;
		rom[7] = 307;
		rom[8] = 5865;
		rom[9] = 6409;
		rom[10] = 6042;
		rom[11] = 6736;
		rom[12] = 2097;
		rom[13] = 3093;
		rom[14] = 6431;
		rom[15] = 4200;
		rom[16] = 6521;
		rom[17] = 6970;
		rom[18] = 1457;
		rom[19] = 2171;
		rom[20] = 6009;
		rom[21] = 3160;
		rom[22] = 352;
		rom[23] = 7420;
		rom[24] = 6798;
		rom[25] = 6961;
		rom[26] = 3420;
		rom[27] = 5407;
		rom[28] = 3071;
		rom[29] = 3200;
		rom[30] = 162;
		rom[31] = 4986;
	end

endmodule
