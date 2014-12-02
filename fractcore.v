`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:17:12 12/01/2014 
// Design Name: 
// Module Name:    fractcore 
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
module fractcore(
input clk,
input [31:0] centerx,
input [31:0] centery,
input [3:0] zoom,
output ready,
output pixel,
output [18:0] write_addr
    );

// default 80; 100 is better
//parameter centerx = 140;
//parameter centery = 60;

reg reset = 1;

// screen x and y
reg [9:0] x = 0;
reg [9:0] y = 0;

// cartesian coords
reg [31:0] cartx;
reg [31:0] carty;

// fractal params
reg [31:0] cR = 0;
reg [31:0] cI = 0;
reg [31:0] zR = 0;
reg [31:0] zI = 0;

reg [5:0] iterations = 0;

assign write_addr = (y * 160) + x;

always @(posedge clk) begin
	if (reset) begin
		reset = 0;
		x = 0;
		y = 0;
		cartx = -centerx;
		carty = centery;
		cR = cartx << 18; // default 18
		cI = carty << 18;
		zR = 0;
		zI = 0;
	end
	else begin
	
		// if pixel was ready, clear it.
		if (ready) begin
			// reset to next pixel
			x = x + 1;
			if (x == 160) begin
				x = 0;
				y = y + 1;
			end
			if (y == 120) begin
				y = 0;
				x = 0;
			end
			iterations = 0;
			cartx = (x - centerx);
			carty = (centery - y);
			// compute c.r and c.i
			cR = cartx << (18-zoom);
			cI = carty << (18-zoom);
			zR = 0;
			zI = 0;
		end
		else begin
			zR = new_zR;
			zI = new_zI;
			iterations = iterations + 1;
		end
	end
end

// combinational logic for computing fractal iterations

wire [31:0] new_zR, new_zI;

wire [63:0] signedzR;
wire [63:0] signedzI;
assign signedzR = {{32{zR[31]}}, zR};
assign signedzI = {{32{zI[31]}}, zI};

wire [63:0] zRsqr;
wire [63:0] zIsqr;
wire [63:0] zRmultzI;
wire [63:0] largezR;
assign zRsqr = signedzR * signedzR;
assign zIsqr = signedzI * signedzI;
assign zRmultzI = ((signedzR * signedzI) * 2);
assign largezR = zRsqr - zIsqr;

// truncate for upper bits
assign new_zI = zRmultzI[55:24] + {{32{cI[31]}},cI};
assign new_zR = largezR[55:24] + {{32{cR[31]}},cR};

// exit condition
wire [63:0] zRsqrPluszIsqr;
assign zRsqrPluszIsqr = zRsqr + zIsqr;
wire f_unbounded = zRsqrPluszIsqr[55:24] > (3'b100 << 24); // shift 24 for proper comparison

assign pixel = ~f_unbounded;
assign ready = f_unbounded | &iterations;

endmodule
