`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    22:59:55 11/16/2014 
// Design Name: 
// Module Name:    screen_mem 
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
module screen_mem(
	input clk,
	input f_write,
	input [7:0] write_code,
	// $clog2(40*30)-1
	input [10:0] addr,
	
	output [7:0] screen_code,
	
	// vga port
	input [10:0] vga_addr,
	output [7:0] vga_code
    );

	// 30*40=1200 locations
	reg [7:0] screen_memory [1199:0];
	initial $readmemb("mem_screen", screen_memory, 0, 1199);
	
	always @(posedge clk)
		screen_memory[addr] <= f_write == 1 ? write_code : screen_memory[addr];
	
	assign screen_code = screen_memory[addr];
	assign vga_code = screen_memory[vga_addr];

endmodule
