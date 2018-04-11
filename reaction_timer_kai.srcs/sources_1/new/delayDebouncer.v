`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 10.04.2018 11:11:17
// Design Name: PS/2 Delay Debouncer 
// Module Name: delayDebouncer
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4 
// Description: This is the special debouncer for PS/2 clock and data wire. The 
// working clock of this module should be 50MHz.
// This debouncer simply detect the past four result. If they are all the same,
// output the data. 
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module delayDebouncer(
    input wire in_reset,
    input wire in_enable,
    input wire in_clock,
	input wire in_signal,
	output reg out_debouncedSignal);
	
	reg [4:0] counter = 5'd0;
	reg lastSignal = 1'b0;
	
	always @(posedge in_clock) begin
	   if (in_reset) begin
	       // Reset the data.
	       counter <= 5'd0;
	       lastSignal = 1'b0;
	   end else begin
	       if (in_enable) begin
	           // Only increase the counter when we found the same data input.
               if (in_signal==lastSignal) begin
                   // When count to 4, output the signal.
                   if (counter==5'd19) begin
                       out_debouncedSignal <= in_signal;
                   end else begin
                       counter <= counter + 1;
                   end
               end else begin
                   // Reset the counter.
                   counter = 5'd16;
                   lastSignal <= in_signal;
               end	           
	       end
	   end
	end
	
endmodule

