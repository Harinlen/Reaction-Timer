`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/17 22:07:04
// Design Name: Global Timer Counter
// Module Name: globalTime
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is just a clock counter. It would just simply count 
// the clock from the start.
// This module could be used as the local time module. 
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module globalTime(
    input wire        in_clock,
    output reg [31:0] out_time = 32'd0);
    
    // Simply count the clock rising edge.
    always @(posedge in_clock) begin
        out_time <= out_time + 32'd1; 
    end
    
endmodule
