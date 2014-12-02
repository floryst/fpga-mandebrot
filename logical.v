`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:52 09/08/2014 
// Design Name: 
// Module Name:    logical 
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
module logical #(parameter N=8) (
    input [N-1:0] A,
    input [N-1:0] B,
    input [1:0] op,
    output [N-1:0] R
    );

assign R = (op == 2'b00) ? (A[N-1:0] & B[N-1:0]) : 
				(op == 2'b01) ? (A[N-1:0] | B[N-1:0]) :
				(op == 2'b10) ? (A[N-1:0] ^ B[N-1:0]) :
				(op == 2'b11) ? ~(A[N-1:0] | B[N-1:0]) : 8'b00000000;

endmodule