`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/17 19:52:30
// Design Name: Integer Counter Clock Divider
// Module Name: clockDivider
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This is an integer clock divider, just the same as the one in the
// Lab.
// The output freq of the default threshold is 1Hz with a 100MHz input clock.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clockDivider #(
    parameter integer THRESHOLD = 50_000_000
)(
    input wire in_clock,
    input wire in_reset,
    input wire in_enable,
    output reg out_dividedClock = 1'b1);
    
    reg [31:0] counter = 32'd0;
    
    always @(posedge in_clock) begin
        // Check the reset state.
        if (in_reset) begin
            // Reset the counter.
            counter <= 32'd0;
            // Reset the clock.
            out_dividedClock <= 1'b1;
        end else begin
            // Check the enable state.
            if (in_enable) begin
                // Check the counter already reaches the limitation.
                if (counter < THRESHOLD - 1) begin
                    // Increase the counter.
                    counter <= counter + 1;
                end else begin
                    // Reverse the counter.
                    out_dividedClock <= ~out_dividedClock;
                    // Reset the counter.
                    counter <= 32'd0;
                end
            end
        end
    end
    
endmodule
