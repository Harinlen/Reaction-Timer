`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/17 22:17:14
// Design Name: Linear Congruential Generator Randomized Generator
// Module Name: randLcg
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: Linear Congruential random number generator.
// By providing the seed it could automatically generate the pseudorandomness 
// number. A global timer would be introduced as backup seed choice.
// 
// Dependencies: 
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module randLcg(
    input wire [31:0] in_globalTime,
    input wire [31:0] in_seed,
    input wire        in_seedReady,
    input wire        in_next,
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    output reg [31:0] out_data = `OUTPUT_INVALID,
    output reg        out_busy = 32'd0);
    
    reg [31:0] seed = 32'd0;
    wire seedReadyRising, nextRising;
    
    task updateSeed;
    input [31:0] lastSeed;
    begin
        // Update the seed.
        seed <= 32'd214013 * lastSeed + 32'd2531011;
    end
    endtask
        
    // Detect the edge of the seed ready signal.
    edgeDetector seedReadyDetector(
        .in_signal(in_seedReady),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(seedReadyRising));

    // Detect the edge of the next signal. 
    edgeDetector nextDetector(
        .in_signal(in_next),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(nextRising));
        
    always @(posedge in_clock) begin
        // Check reset signal.
        if (in_reset) begin
            // Reset the output signals, initialized the data.
            out_busy <= `OUTPUT_INVALID;
            out_data <= 32'd0;
            // Update the local seed..
            seed <= 32'd0;
        end else begin
            if (in_enable) begin
                // Check the rising edge of seed ready.
                if (seedReadyRising) begin
                    // Initialized the data as updated seed.
                    updateSeed((in_seed == 32'd0) ? in_globalTime : in_seed);
                end else begin
                    // Check the rising edge of next seed.
                    if (nextRising) begin
                        //Update the seed with the last seed.
                        updateSeed(seed);
                    end
                end
            end
            // Refresh output data at each clock cycle.
            // Seed is the number we need to output.
            out_data <= seed; 
        end
    end
    
endmodule
