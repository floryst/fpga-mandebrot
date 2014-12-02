`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    09:42:19 11/17/2014 
// Design Name: 
// Module Name:    bitmap_mem 
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
module bitmap_mem #(parameter addrbits=10) (
	input [addrbits-1:0] addr,
	output [7:0] pixel
    );

	// 2 bitmap chars sized 16x16
	reg [7:0] bitmap_memory [511:0];
	initial $readmemh("mem_bitmap", bitmap_memory, 0, 511);
	
	assign pixel = bitmap_memory[addr];

endmodule
