`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/17 23:28:09
// Design Name: Non-Delay Latched Debouncer
// Module Name: latchDebouncer
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This is the debouncer which similar to the one used for rotary 
// encoder. It will detect the first rising edge of the button and hold it for 
// several times.
// The default parameter would be latch the result for 0.1ms for a 100MHz input
// clock.
// 
// Dependencies: 
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module latchDebouncer #(
    parameter integer INTERVAL = 10_000
)(
    input wire          in_clock,
    input wire          in_enable,
    input wire          in_reset,
    input wire          in_buttonIn,
    output reg          out_buttonOut = 1'b0);
    
    // Define the internal states of the debouncer.
    localparam STATE_WAITING = 1'b0;
    localparam STATE_LATCHED = 1'b1;
    
    reg [$clog2(INTERVAL)-1:0] intervalCounter = 0;
    reg state = STATE_WAITING;
    wire buttonInRising;
    
    // Detect the first rising edge of the button in signal.
    edgeDetector buttonInDetector(
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(1'b1),
        .in_signal(in_buttonIn),
        .out_risingEdge(buttonInRising));
        
    always @(posedge in_clock) begin
        // Check reset signal.
        if (in_reset) begin
            // Reset the button output.
            out_buttonOut <= 1'b0;
            state <= STATE_WAITING;
            intervalCounter <= 0;
        end else begin
            // Check enabled.
            if (in_enable) begin
                // Check current state
                if (state) begin
                    // STATE_LATCHED
                    // Check the counter.
                    if (intervalCounter < INTERVAL-1) begin
                        // Increase the counter.
                        intervalCounter <= intervalCounter + 1;
                    end else begin
                        // Clear the output.
                        out_buttonOut <= 1'b0;
                        // Reset the state.
                        state <= STATE_WAITING;
                    end
                end else begin
                    // Check the button in signal rising edge.
                    if (buttonInRising) begin
                        // Set the button to 1.
                        out_buttonOut <= 1'b1;
                        // Update the state.
                        state <= STATE_LATCHED;
                        // Reset the interval counter to 0.
                        intervalCounter <= 0;
                    end
                end
            end
        end
    end
   
endmodule
