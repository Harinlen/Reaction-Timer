`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
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
// This modified version will contain four equations to increase the complexity
// of the final result.
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
    output reg [31:0] out_data = 32'd0,
    output wire       out_busy);
    
    localparam STATE_IDLE = 2'd0;
    localparam STATE_MULTIPLY = 2'd1;
    localparam STATE_ADD = 2'd2;
    reg [1:0] state = STATE_IDLE;
    
    // We have four equations to make this result more complex.
    /*                    Multiplier    Increment
     * Numerical Recipes: 1664525       1013904223
     *      Apple Carbon: 16807         0
     *             C++11: 48271         0 
     *      Visual C/C++: 214013        2531011
     */
    reg [1:0] equation = 2'd0;
    
    reg [31:0] seed = 32'd0;
    wire seedReadyRising, nextRising;
        
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
            out_data <= 32'd0;
            // Update the local seed..
            seed <= 32'd0;
        end else begin
            if (in_enable) begin
                case(state)
                STATE_IDLE: begin
                    // Check the rising edge of seed ready.
                    if (seedReadyRising) begin
                        // Initialized the data as updated seed.
                        seed<= ((in_seed == 32'd0) ? in_globalTime : in_seed);
                        // Jump to busy state.
                        state <= STATE_MULTIPLY;
                    end else begin
                        // Check the rising edge of next seed.
                        if (nextRising) begin
                            //Update the seed with the last seed.
                            seed <= ((seed == 32'd0) ? in_globalTime : seed);
                            // Jump to busy state.
                            state <= STATE_MULTIPLY;
                        end
                    end
                end
                STATE_MULTIPLY: begin
                    // Move to add stage.
                    // Update the seed.
                    case (equation)
                        2'd0: seed <= 32'd1664525 * seed;
                        2'd1: seed <= 32'd16807 * seed;
                        2'd2: seed <= 32'd48271 * seed;
                        2'd3: seed <= 32'd214013 * seed;
                    endcase
                    // Jump the state back to add.
                    state = STATE_ADD;
                end
                STATE_ADD: begin
                    // Complete the calculation.
                    case (equation)
                        2'd0: seed <= seed + 32'd2531011; 
                        2'd1: seed <= seed;
                        2'd2: seed <= seed;
                        2'd3: seed <= seed + 32'd1013904223;
                    endcase
                    // Switch the equation index.
                    equation <= {seed[6], seed[9]};
                    // Jump the state back to idle.
                    state = STATE_IDLE;
                end
                endcase                
            end
            // Refresh output data at each clock cycle.
            // Seed is the number we need to output.
            out_data <= seed; 
        end
    end
    
    assign out_busy = (state != STATE_IDLE);
    
endmodule
