module exceed_addr_dec
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
		rom[128] = 0;
		rom[129] = 8;
		rom[130] = 32;
		rom[131] = 40;
		rom[132] = 64;
		rom[133] = 72;
		rom[134] = 96;
		rom[135] = 104;
		rom[136] = 128;
		rom[137] = 136;
		rom[138] = 160;
		rom[139] = 168;
		rom[140] = 192;
		rom[141] = 200;
		rom[142] = 224;
		rom[143] = 232;
		rom[160] = 0;
		rom[161] = 8;
		rom[162] = 16;
		rom[163] = 24;
		rom[164] = 64;
		rom[165] = 72;
		rom[166] = 80;
		rom[167] = 88;
		rom[168] = 128;
		rom[169] = 136;
		rom[170] = 144;
		rom[171] = 152;
		rom[172] = 192;
		rom[173] = 200;
		rom[174] = 208;
		rom[175] = 216;
		rom[192] = 0;
		rom[193] = 8;
		rom[194] = 16;
		rom[195] = 24;
		rom[196] = 32;
		rom[197] = 40;
		rom[198] = 48;
		rom[199] = 56;
		rom[200] = 128;
		rom[201] = 136;
		rom[202] = 144;
		rom[203] = 152;
		rom[204] = 160;
		rom[205] = 168;
		rom[206] = 176;
		rom[207] = 184;
		rom[224] = 0;
		rom[225] = 8;
		rom[226] = 16;
		rom[227] = 24;
		rom[228] = 32;
		rom[229] = 40;
		rom[230] = 48;
		rom[231] = 56;
		rom[232] = 64;
		rom[233] = 72;
		rom[234] = 80;
		rom[235] = 88;
		rom[236] = 96;
		rom[237] = 104;
		rom[238] = 112;
		rom[239] = 120;
	end

endmodule
