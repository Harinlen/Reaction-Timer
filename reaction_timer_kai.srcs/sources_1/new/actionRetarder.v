`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/17 18:35:31
// Design Name: Action Delayer
// Module Name: actionRetarder
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to deplay one input pulse after a specific
// time. The time would be used as a 32-bit input integer. This is the count of the
// input clock. Delay for several clock cycles, and then output a pulse.
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

module actionRetarder(
    input wire [31:0] in_delayCounts,
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    input wire        in_pulseIn,
    output reg        out_pulseOut = 1'b0);
    
    // Defines the working state.
    localparam STATE_PENDING = 2'b00;
    localparam STATE_WAITING = 2'b01;
    localparam STATE_FINISH = 2'b10;
    
    reg [31:0] counter = 32'd0, limits = 32'd0;
    reg [1:0] state = STATE_PENDING;
    wire pulseInRising;
    
    edgeDetector signalInDetector(
        .in_signal(in_pulseIn),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(pulseInRising));
    
    always @(posedge in_clock) begin
        // Check for the reset signal.
        if (in_reset) begin
            // Reset the counter.
            counter <= 32'd0;
            limits <= 32'd0;
            // Reset the output pulse signal.
            out_pulseOut <= 1'b0;
            state <= STATE_PENDING;
        end else begin
            // Check enable state.
            if (in_enable) begin
                // Check the current state.
                if (state == STATE_FINISH) begin
                    // FINISH state.
                    // Reset the state back to pending.
                    state <= STATE_PENDING;
                    // Reset the signal.
                    out_pulseOut <= 1'b0;
                end else if (state == STATE_WAITING) begin
                    // WAITING state.
                    // Count until to the limits.
                    if (counter < limits) begin
                        // Increase the counter.
                        counter <= counter + 1; 
                    end else begin
                        // The counter reach the limits.
                        state <= STATE_FINISH;
                        // Rise the output signal.
                        out_pulseOut <= 1'b1;
                    end
                end else begin
                    // PENDING state.
                    // Wait until for the pulse in rising.
                    if (pulseInRising) begin
                        // Moving state to waiting.
                        state <= STATE_WAITING;
                        // Save the current delay counts as limits.
                        limits <= in_delayCounts;
                        // Reset the counter.
                        counter <= 32'd0;
                    end
                end
            end
        end
    end
    
endmodule
