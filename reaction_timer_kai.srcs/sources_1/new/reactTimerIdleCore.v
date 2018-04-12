`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
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
    parameter integer ANIMATION_THRESHOLD = 12_500_000,
    parameter integer BEST_RESULT_PWM_DELAY = 0
)(
    input wire [27:0]  in_reactionTime,
    input wire [31:0]  in_reactionSsd,
    input wire         in_reactionTimeout,
    input wire         in_reactionTimeValid,
    input wire         in_animeReset,
    input wire         in_clearBest,
    input wire         in_clock,
    input wire         in_reset,
    input wire         in_enable,
    output wire        out_bestLevelRPwm, 
    output wire        out_bestLevelGPwm, 
    output wire        out_bestLevelBPwm,
    output reg [27:0]  out_bestTime = 28'd0,
    output wire [15:0] out_leds,
    output wire [31:0] out_ssdOutput,
    output wire [7:0]  out_ssdDots);
    
    reg [31:0] bestTimeDigits = 32'd0;
    wire [7:0] resultLevel;
    reg [7:0] bestResultLevelR = 8'd0, bestResultLevelG = 8'd0, bestResultLevelB = 8'd0;
    assign resultLevel = in_reactionTime[27:20];
    
    // Result level PWM Modem
    // Red
    PwmModem #(
        .COUNTER_DELAY(BEST_RESULT_PWM_DELAY) 
    ) resultLevelRPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .in_numberIn(bestResultLevelR),
        .out_pwmWave(out_bestLevelRPwm));
    // Green
    PwmModem #(
        .COUNTER_DELAY(BEST_RESULT_PWM_DELAY) 
    ) resultLevelGPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .in_numberIn(bestResultLevelG),
        .out_pwmWave(out_bestLevelGPwm));
    // Blue
    PwmModem #(
        .COUNTER_DELAY(BEST_RESULT_PWM_DELAY) 
    ) resultLevelBPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .in_numberIn(bestResultLevelB),
        .out_pwmWave(out_bestLevelBPwm));
    
    // Best reaction time.
    always @(posedge in_clock) begin
        // Check reset signal.
        if (~in_reset) begin
            if (in_enable) begin
                // Check the clear best signal.
                if (in_clearBest) begin
                    // Reset the best time and best time digits.
                    out_bestTime <= 28'd0;
                    bestTimeDigits <= 32'd0;
                    // Reset the RGB.
                    bestResultLevelR <= 8'd0;
                    bestResultLevelG <= 8'd0;
                    bestResultLevelB <= 8'd0;
                end else begin
                    // We need to compare the input time as the best time.
                    if (in_reactionTimeValid) begin
                        // Compare the reaction time with best time.
                        if (out_bestTime == 28'd0 || (~in_reactionTimeout & (in_reactionTime < out_bestTime))) begin
                            // New records saved.
                            out_bestTime <= in_reactionTime;
                            bestTimeDigits <= in_reactionSsd;
                            // Update the best time RGB.
                            if (~in_reactionTimeout) begin
                                bestResultLevelR <= (resultLevel < 52) ? 255 : ((resultLevel < 102) ? ((102-resultLevel)*5) : ((resultLevel < 204) ? 0 : ((resultLevel-204)*5)));
                                bestResultLevelG <= (resultLevel < 51) ? (resultLevel * 5) : ((resultLevel < 153) ? 255 : ((resultLevel < 204) ? ((204-resultLevel)*5) : 0));
                                bestResultLevelB <= (resultLevel < 102) ? 0 : ((resultLevel > 153) ? 255 : ((resultLevel - 102) * 5));
                            end
                        end
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
    assign out_ssdOutput = (out_bestTime > 0) ? bestTimeDigits : `SSD_DISPLAY_MINUS;
    assign out_ssdDots = (out_bestTime > 0) ? 8'b0111_1111 : 8'b1111_1111;
    
endmodule
