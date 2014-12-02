`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:00 09/08/2014 
// Design Name: 
// Module Name:    addsub 
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
module addsub #(parameter N=8)(
    input [N-1:0] A,
    input [N-1:0] B,
    input Subtract,
    output [N-1:0] Result,
    output FlagN,
    output FlagC,
    output FlagV
    );

wire [N-1:0] ToBornottoB;

assign ToBornottoB = (Subtract) ? ~B : B;
adder #(N) add(A, ToBornottoB, Subtract, Result, FlagN, FlagC, FlagV);

endmodule
