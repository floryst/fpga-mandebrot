`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    00:12:08 09/09/2014 
// Design Name: 
// Module Name:    ALU 
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
module ALU #(parameter N=32) (
    input [N-1:0] A,
    input [N-1:0] B,
    input [4:0] ALUfn,
    output [N-1:0] R,
    output FlagZ
    );

assign {subtract,bool1,bool0,shft,math} = ALUfn[4:0];
wire [N-1:0] addsubResult, shiftResult, logicalResult;
wire comparison;

addsub #(N) component_addsub(A, B, subtract, addsubResult, FlagN, FlagC, FlagV);
shifter #(N) component_shifter(B, A[4:0], ~bool1, ~bool0, shiftResult);
logical #(N) component_logical(A, B, {bool1, bool0}, logicalResult);
comparator component_comparator(FlagN, FlagC, FlagV, bool0, comparison);

assign R = (~shft & math) ? addsubResult :
			(shft & ~math) ? shiftResult :
			(~shft & ~math) ? logicalResult : comparison;
			
assign FlagZ = ~|R;
endmodule
