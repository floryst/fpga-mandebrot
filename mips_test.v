`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest li
//
// Create Date:   11:23:28 11/16/2014
// Design Name:   top
// Module Name:   /home/hatch/MIPS/mips_test.v
// Project Name:  MIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_test;

	// Inputs
	reg clk;
	reg rst;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#0.5 $finish;
        
		// Add stimulus here

	end
   
	initial begin
		#0.5 clk = 0;
	forever 
		#0.5 clk = ~clk;
	end
	
endmodule

