`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    11:09:41 11/16/2014 
// Design Name: 
// Module Name:    instr_mem 
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
module instr_mem(
	input [31:0] pc,
	output [31:0] instr
    );

	// 128 locations
	// 32-bit data
	reg [31:0] memory [63:0];
	initial $readmemb("mem_instr", memory, 0, 63);

	assign instr = memory[ {2'b0, pc[31:2]} ];

endmodule
