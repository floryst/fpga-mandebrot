`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:48 08/26/2014 
// Design Name: 
// Module Name:    lab_part1 
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
module fulladder (
    input A,
    input B,
    input Cin,
    output Sum,
	 output Cout
    );

	wire X;
	assign X = A ^ B;
	assign Sum = Cin ^ X;
	assign Cout = (Cin & X) | (A & B);

endmodule
