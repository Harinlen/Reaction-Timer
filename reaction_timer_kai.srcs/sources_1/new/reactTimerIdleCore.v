`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/18 10:18:09
// Design Name: IDLE State Logic Processor
// Module Name: reactTimerIdleCore
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module designed to handle the idle state.
// This module would be responsed for the following function.
//  1. Save and show the history best time.
//  2. Show the idle LED animations. To reset the animation only,
//     Set in_animeReset to 1.
// 
// Dependencies: 
//    - clockDivider
//    - ledAnimation
//    - digitSeperator
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module reactTimerIdleCore #(
    parameter integer ANIMATION_THRESHOLD = 12_500_000
)(
    input wire [27:0]  in_reactionTime,
    input wire [31:0]  in_reactionSsd,
    input wire         in_reactionTimeout,
    input wire         in_reactionTimeValid,
    input wire         in_animeReset,
    input wire         in_clock,
    input wire         in_reset,
    input wire         in_enable,
    output wire [27:0] out_bestTime,
    output wire [15:0] out_leds,
    output wire [31:0] out_ssdOutput,
    output wire [7:0]  out_ssdDots);
    
    reg [27:0] bestTime = 28'd0;
    reg [31:0] bestTimeDigits = 32'd0;
    
    // Best reaction time.
    always @(posedge in_clock) begin
        // Check reset signal.
        if (~in_reset) begin
            if (in_enable) begin
                // We need to compare the input time as the best time.
                if (in_reactionTimeValid) begin
                    // Compare the reaction time with best time.
                    if (bestTime == 28'd0 || (~in_reactionTimeout & (in_reactionTime < bestTime))) begin
                        // New records saved.
                        bestTime <= in_reactionTime;
                        bestTimeDigits <= in_reactionSsd;
                    end
                end
            end
        end
    end
    
    wire animeClock;
    
    // Generate a slower clock for LED animation.
    clockDivider #(
        .THRESHOLD(ANIMATION_THRESHOLD)
    ) ledAnimeClock (
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_dividedClock(animeClock));
    
    // LED animation.
    ledAnimation idleAnimation(
        .in_clock(in_clock),
        .in_animeClock(animeClock),
        .in_reset(in_reset | in_animeReset),
        .in_enable(in_enable),
        .out_leds(out_leds));
    
    // Set the output time data.
    assign out_ssdOutput = (bestTime > 0) ? bestTimeDigits : `SSD_DISPLAY_MINUS;
    assign out_ssdDots = (bestTime > 0) ? 8'b0111_1111 : 8'b1111_1111;
    assign out_bestTime = bestTime;
    
endmodule
