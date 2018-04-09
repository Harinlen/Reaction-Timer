`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 06.04.2018 15:52:17
// Design Name: Microphone Noise Random Number Generator
// Module Name: microphoneNoiseGenerator
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to collect the signal from the microphone
// and store the data into a 32-bit left-shift register.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module microphoneNoiseGenerator(
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    input wire        in_rawData,
    output reg [31:0] out_mcData = 32'd0,
    output wire       out_mcClock,
    output wire       out_mcLRSelect);
    
    // 3.125MHz microphone working clock.
    reg [4:0] mcClock = 5'd0;
    
    always @(posedge in_clock) begin
        // Check reset.
        if (in_reset) begin
            // Reset the clock.
            mcClock <= 5'd0;
            // Reset the microphone output.
            out_mcData <= 32'd0;
        end else begin
            if (in_enable) begin
                // Increase the clock.
                mcClock <= mcClock + 1;
                // Check the clock counter.
                if (mcClock == 5'b01111) begin
                    // Half of the clock, read the data.
                    out_mcData <= {out_mcData[30:0], in_rawData};
                end
            end
        end
    end
    
    // Assign the clock, assign the MSB of the counter as the driven clock.
    assign out_mcClock = mcClock[4];
    // Microphone L/R channel selection.
    assign out_mcLRSelect = 1'b1;

endmodule