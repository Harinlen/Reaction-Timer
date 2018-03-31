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
    input wire         in_startRising,
    input wire         in_reset,
    input wire         in_enable,
    input wire         in_clock,
    output reg         out_busy = 1'b0,
    output wire [31:0] out_numberDisplay,
    output reg [31:0]  out_delay = 32'd0);
    
    localparam STATE_WAITING = 1'b0;
    localparam STATE_GENRAND = 1'b1;
    
    localparam RAND_LCG = 1'b0;
    localparam RAND_MT  = 1'b1;
    // Initial set as LCG.
    reg randSelector = RAND_LCG;
    
    reg [2:0] busyWait = 3'd0;
    reg [31:0] seed = 0;
    reg seedReady = 0, next = 0, state = STATE_WAITING, seedSet = 0;
    wire [31:0] randLcgOut, randMtOut;
    wire randLcgBusy, randMtBusy, animationBusy;
    
    // Random number generator.
    // Linear Congruential Generator
    randLcg gapGeneratorLcg(
        .in_globalTime(in_globalTime),
        .in_seed(seed),
        .in_seedReady(seedReady),
        .in_next(next),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_data(randLcgOut),
        .out_busy(randLcgBusy));
    // Mt19937 Generator
    randMt19937 gapGeneratorMt19937(
        .in_globalTime(in_globalTime),
        .in_seed(seed),
        .in_seedReady(seedReady),
        .in_next(next),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_data(randMtOut),
        .out_busy(randMtBusy));
        
    // Animation playing module.
    ssdAnimation #(
        .ANIME_CLOCK_THRESHOLD(COUNT_DOWN_CLOCK_THRESHOLD)
    ) prepareAnimation (
        .in_startRising(in_startRising & (~out_busy)),
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
                // Reset the seed ready and next signal.
                seedReady <= 0;
                next <= 0;
                // Check the current state.
                if (state) begin
                    // STATE_GENRAND
                    // First, it need to pass busy waiting.
                    if (busyWait > 3'd0) begin
                        // Count down on busy waiting.
                        busyWait <= busyWait - 1;
                    end else begin
                        // Check the current using random number generator.
                        case(randSelector)
                            RAND_LCG: begin
                                // Check Linear Congruential Generator busy output.
                                if (~randLcgBusy) begin
                                    // Set the randomize time to output.
                                    // Limit the time up to 8.05 seconds.
                                    out_delay <= (TEST_DELAY_TIME > 0) ? TEST_DELAY_TIME : {3'd0, randLcgOut[28:0]} + {4'd0, randLcgOut[27:0]};
                                end 
                            end
                            RAND_MT: begin
                                // Check Mt19937 busy output.
                                if (~randMtBusy) begin
                                    // Set the randomize time to output.
                                    out_delay <= (TEST_DELAY_TIME > 0) ? TEST_DELAY_TIME : {3'd0, randMtOut[28:0]} + {4'd0, randMtOut[27:0]};
                                end
                            end
                        endcase
                        // Waiting all the mission complete.
                        if ((~randLcgBusy) & (~randMtBusy) & (~animationBusy)) begin
                            // Switch random number generator.
                            case(randSelector)
                                RAND_LCG: randSelector <= RAND_MT;
                                RAND_MT: randSelector <= RAND_LCG;
                            endcase
                            // Reset the state back to waiting.
                            state <= STATE_WAITING;
                            // No more busy.
                            out_busy <= 0;
                        end
                    end
                    
                end else begin
                    // STATE_WAITING
                    // Waiting for start button signal.
                    if (in_startRising) begin
                        // Change state to Generating Random number.
                        state <= STATE_GENRAND;
                        // Also enable the seed ready signal.
                        next <= 1;
                        //if (seedSet) begin
                        //    // Request for next random number.
                        //    next <= 1;
                        //end else begin
                        //    // Set the seed.
                        //    seedReady <= 1;
                        //end
                        // This module is about to being busy.
                        out_busy <= 1'b1;
                        // Enable the busy waiting.
                        busyWait <= 3'd7;
                    end
                end
            end
        end
    end
    
endmodule
