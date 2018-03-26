`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/18 15:30:48
// Design Name: PREPARE State Logic Processor
// Module Name: reactTimerPrepareCore
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is design to generate the random number, and play the
// count down animations.
// The inner states contain:
//      1. Waiting state: this state doesn't operate anything.
//      2. Generating Number state: until the pulse of start signal passing in,
//         this state won't enable. This would enable the next signal to the random
//         number generator until the number is ready.
//         During this state, animation would be play at the same time.
//      3. When the number generate complete and animation complete, the state would
//         be back to Waiting state.
// The output out_delay would output the randomized number of duration.
// 
// Dependencies: 
//    - randLcg
//    - edgeDetector
//    - ssdAnimation
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module reactTimerPrepareCore #(
    parameter integer COUNT_DOWN_CLOCK_THRESHOLD = 50_000_000,
    parameter integer TEST_DELAY_TIME = 0
)(
    input wire [31:0]  in_globalTime,
    input wire         in_start,
    input wire         in_reset,
    input wire         in_enable,
    input wire         in_clock,
    output reg         out_busy = 1'b0,
    output wire [31:0] out_numberDisplay,
    output reg [31:0]  out_delay = 32'd0);
    
    localparam STATE_WAITING = 1'b0;
    localparam STATE_GENRAND = 1'b1;
    
    reg [31:0] seed = 0;
    reg seedReady = 0, next = 0, state = STATE_WAITING, seedSet = 0;
    wire [31:0] randOut;
    wire randLcgBusy, animationBusy, startRising;
    
    // Random number generator.
    randLcg gapGeneratorLcg(
        .in_globalTime(in_globalTime),
        .in_seed(seed),
        .in_seedReady(seedReady),
        .in_next(next),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_data(randOut),
        .out_busy(randLcgBusy));
        
    // Detect the rising edge of start signal.
    edgeDetector startRisingDetector(
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_signal(in_start),
        .out_risingEdge(startRising));
        
    // Animation playing module.
    ssdAnimation #(
        .ANIME_CLOCK_THRESHOLD(COUNT_DOWN_CLOCK_THRESHOLD)
    ) prepareAnimation (
        .in_startRising(startRising),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_busy(animationBusy),
        .out_numberDisplay(out_numberDisplay));
    
    always @(posedge in_clock) begin
        // Check reset signal.
        if (in_reset) begin
            // Reset the seed.
            seed <= 32'd0;
            // Reset parameters.
            seedReady <= 0;
            next <= 0;
            // Reset the state.
            state <= STATE_WAITING;
            // Reset the output.
            out_delay <= 32'd0;
            out_busy <= 1'b0;
        end else begin
            if (in_enable) begin
                // Check the current state.
                if (state) begin
                    // STATE_GENRAND
                    // Wait until the busy signal is 0.
                    if (~randLcgBusy) begin
                        // Set the randomize time to output.
                        // Limit the time up to 5 seconds.
                        out_delay <= (TEST_DELAY_TIME > 0) ? TEST_DELAY_TIME : (randOut % 32'd700_000_000);
                    end
                    // Waiting the animation complete.
                    if ((~randLcgBusy) & (~animationBusy)) begin
                        // Reset the state back to waiting.
                        state <= STATE_WAITING;
                        // Reset the seed ready and next signal.
                        seedReady <= 0;
                        next <= 0;
                        // No more busy.
                        out_busy <= 0;
                    end
                end else begin
                    // STATE_WAITING
                    // Waiting for start button signal.
                    if (startRising) begin
                        // Change state to Generating Random number.
                        state <= STATE_GENRAND;
                        // Also enable the seed ready signal.
                        if (seedSet) begin
                            // Request for next random number.
                            next <= 1;
                        end else begin
                            // Set the seed.
                            seedReady <= 1;
                        end
                        // This module is about to being busy.
                        out_busy <= 1'b1;
                    end else begin
                    end
                end
            end
        end
    end
    
endmodule
