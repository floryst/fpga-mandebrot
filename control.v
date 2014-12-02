`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: COMP 541
// Engineer: Forrest Li
// 
// Create Date:    12:49:45 11/16/2014 
// Design Name: 
// Module Name:    control 
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
module control(
	input [5:0] opcode,
	input [5:0] func,
	
	output [4:0] alufn,
	output f_memwrite,
	output f_regwrite,
	output f_bne,
	output f_beq,
	output f_zeroextend,
	output f_dst_rt_rd,
	output f_shiftval,
	output f_alusrc,
	output f_mem2reg,
	output f_jump1,
	output f_jump2,
	output f_lui
    );

reg [16:0] controls;
assign {f_lui, f_jump2, f_jump1, f_mem2reg, f_alusrc, f_shiftval, f_dst_rt_rd, f_zeroextend, 
	f_bne, f_beq, f_memwrite, f_regwrite, alufn} = controls;

always @(*)
	case (opcode)
		6'b000000: begin // alu + jr
			case (func)
				6'b100000: controls <= 17'b000000100001_0XX01; // add
				6'b100010: controls <= 17'b000000100001_1XX01; // sub
				6'b100110: controls <= 17'b000000100001_X1000; // xor
				6'b100100: controls <= 17'b000000100001_X0000; // and
				6'b100101: controls <= 17'b000000100001_X0100; // or
				6'b000000: controls <= 17'b000001100001_X0010; // sll
				6'b000100: controls <= 17'b000000100001_X0010; // sllv
				6'b000011: controls <= 17'b000001100001_X1010; // sra
				6'b000010: controls <= 17'b000001100001_X1110; // srl
				6'b000110: controls <= 17'b000000100001_X1110; // srv
				6'b101010: controls <= 17'b000000100001_1X011; // slt
				6'b001000: controls <= 17'b010000000000_XXXXX; // jr
				default: controls <= 17'b000000000000_XXXXX;
			endcase
			end
		6'b000100: controls <= 17'b000000000100_1XX01; // beq
		6'b000101: controls <= 17'b000000001000_1XX01; // bne
		6'b001101: controls <= 17'b000010010001_X0100; // ori
		6'b001100: controls <= 17'b000010010001_X0000; // andi
		6'b001110: controls <= 17'b000010010001_X1000; // xori
		6'b001000: controls <= 17'b000010000001_0XX01; // addi
		6'b001010: controls <= 17'b000010000001_1X011; // slti
		6'b101011: controls <= 17'b000010000010_0XX01; // sw
		6'b100011: controls <= 17'b000110000001_0XX01; // lw
		6'b000010: controls <= 17'b001000000000_XXXXX; // j
		6'b000011: controls <= 17'b011000000001_XXXXX; // jal
		6'b001111: controls <= 17'b100000000001_XXXXX; // lui
		default: controls <= 17'bXXXXXXXXXXXX_XXXXX;
	endcase

endmodule
