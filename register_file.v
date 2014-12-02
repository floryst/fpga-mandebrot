`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    12:33:02 11/16/2014 
// Design Name: 
// Module Name:    register_file 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module register_file(
	input clk,
	input f_regwrite,
	input [4:0] reg1,
	input [4:0] reg2,
	input [4:0] writereg,
	input [31:0] writedata,
	
	output [31:0] reg1out,
	output [31:0] reg2out
    );

	reg [31:0] register_file [31:0];
	initial $readmemb("regfile", register_file, 0, 31);
	
	always @(posedge clk)
		if (f_regwrite)
			register_file[writereg[4:0]] <= writereg == 5'b0 ? 5'b0 : writedata[31:0];
		else
			register_file[writereg[4:0]] <= register_file[writereg[4:0]];
	
	assign reg1out = register_file[reg1[4:0]];
	assign reg2out = register_file[reg2[4:0]];

endmodule
