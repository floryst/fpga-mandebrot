`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Montek Singh
// 11/15/2014 
//
//////////////////////////////////////////////////////////////////////////////////


module clockdivider_Nexys4(input clkin, output clk100, output clk50, output clk25, output clk12);

   MMCME2_BASE #(.CLKOUT0_DIVIDE_F(10), .CLKOUT1_DIVIDE(20), .CLKOUT2_DIVIDE(40), .CLKOUT3_DIVIDE(80),
            .CLKFBOUT_MULT_F(10), .CLKIN1_PERIOD(10.0)) 
            mmcm (.CLKOUT0(clkout0), .CLKOUT1(clkout1), .CLKOUT2(clkout2), .CLKOUT3(clkout3),
               .CLKFBOUT(clkfbout), .LOCKED(locked), .CLKIN1(clkin), .PWRDWN(1'b0),
               .RST(1'b0), .CLKFBIN(clkfbin));


   BUFG   bufclkfb (.I(clkfbout), .O(clkfbin));

   localparam N=2;
   reg [N:0] start_cnt=0;           // Count 2^N clock cycles of 100 MHz clock
   wire clock_enable=locked & start_cnt[N];  // Delay clock outputs by 2^N clock cycles of 100 MHz clock after lock
   always @(posedge clkout0) begin
      if (locked & (start_cnt[N] != 1'b1))
         start_cnt <= start_cnt + 1'b1;
   end

   INV I1 (.I(clock_enable), .O(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf100 (.O(clk100), .I0(clkout0), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf50  (.O(clk50),  .I0(clkout1), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf25  (.O(clk25),  .I0(clkout2), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf12  (.O(clk12),  .I0(clkout3), .I1(1'b0), .S(not_clock_enable));
   
endmodule


module clockdivider_Nexys3(input clkin, output clk100, output clk50, output clk25, output clk12);

   DCM_SP #(.CLKDV_DIVIDE(2), .CLKFX_MULTIPLY(2), .CLKFX_DIVIDE(8), .CLKIN_DIVIDE_BY_2("TRUE")) dcm (
            .CLKIN(clkin), .CLKFB(clkfb), .RST(1'b0), .PSEN(1'b0),
            .CLK0(clk0), .CLK90(), .CLK180(), .CLK270(),
            .CLK2X(), .CLK2X180(), .CLKDV(clkdv), .CLKFX(clkfx), .LOCKED(locked));

   BUFG   bufclkfb (.I(clk0), .O(clkfb));

   localparam N=2;
   reg [N:0] start_cnt=0;           // Count 2^N clock cycles of 50 MHz clock
   wire clock_enable=locked & start_cnt[N];  // Delay clock outputs by 2^N clock cycles of 50 MHz clock after lock
   always @(posedge clkfb) begin
      if (locked & (start_cnt[N] != 1'b1))
         start_cnt <= start_cnt + 1'b1;
   end
   
   INV I1 (.I(clock_enable), .O(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf100 (.O(clk100), .I0(clkin), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf50  (.O(clk50),  .I0(clk0),  .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf25  (.O(clk25),  .I0(clkdv), .I1(1'b0), .S(not_clock_enable));
   BUFGMUX #(.CLK_SEL_TYPE("ASYNC")) buf12  (.O(clk12),  .I0(clkfx), .I1(1'b0), .S(not_clock_enable));
   
endmodule