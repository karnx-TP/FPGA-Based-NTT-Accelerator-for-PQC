//----------------------------------------
// File : bram_dp_byte.sv
// Author : Thitipong Pav
// Desc : synthesizable word addressed dual port BRAM
//----------------------------------------

module bram_dp_word #(
    parameter DEPTH = 1024,
    parameter XLEN = 16
) (
    clk,
    
    enA,
    wrEnA,
    addrA,
    dataA,
    outA,

	enB,
    wrEnB,
    addrB,
    dataB,
    outB
);
localparam ADDRWIDTH = $clog2(DEPTH);
//Port
    input logic						clk;
    input logic                     enA;
    input logic						wrEnA;
	input logic[ADDRWIDTH-1:0]		addrA;
	input logic[XLEN-1:0]			dataA;
	output logic[XLEN-1:0]			outA;

	input logic                     enB;
    input logic						wrEnB;
	input logic[ADDRWIDTH-1:0]		addrB;
	input logic[XLEN-1:0]			dataB;
	output logic[XLEN-1:0]			outB;

//Memory
    (* ram_style = "block" *)reg[XLEN-1:0]   ram [0:DEPTH-1];
	
//reg Addr

    //Write
	always @(posedge clk) begin
		if(enA & wrEnA)begin
			ram[addrA]<= dataA; 
		end
	end
	always @(posedge clk) begin
		if(enB & wrEnB)begin
			ram[addrB]<= dataB; 
		end
	end


    //Read
    always @(posedge clk) begin
        if(enA)begin
            outA <= ram[addrA];
        end
    end
	always @(posedge clk) begin
        if(enB)begin
            outB <= ram[addrB];
        end
    end
    
    
endmodule