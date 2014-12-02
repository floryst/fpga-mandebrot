`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:07 11/16/2014 
// Design Name: 
// Module Name:    data_mem 
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
module data_mem(
	input clk,
	input f_memwrite,
	input [12:0] addr,
	input [31:0] writedata,
	
	output [31:0] readdata,
	
	// fractcore params
	output [31:0] fcpanX,
	output [31:0] fcpanY,
	output [31:0] fcZoom
    );

	reg [31:0] memory [31:0];
	initial $readmemb("mem_data", memory, 0, 31);
	
	always @(posedge clk)
		memory[addr[4:0]] <= f_memwrite == 1 ? writedata : memory[addr[4:0]];
	
	assign readdata = memory[addr[4:0]];
	
	// fractcore params
	assign fcpanX = memory[5'b11111];
	assign fcpanY = memory[5'b11110];
	assign fcZoom = memory[5'b11101];

endmodule
