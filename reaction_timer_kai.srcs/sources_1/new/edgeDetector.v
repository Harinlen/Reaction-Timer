`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/17 16:25:11
// Design Name: Lower Frequency Signal Edge Detector
// Module Name: edgeDetector
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to detect the signal's rising edge and falling
// edge with a 100MHz clock. The signal must be debounced.
// The detect result would be one clock cycle slower than the input signal.
// This detector cannot detect the edge of the signal exactly the same as the clock.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
//          0.02 - Kai. For using the new detector.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module edgeDetector(
    input wire  in_signal,
    input wire  in_clock,
    input wire  in_reset,
    input wire  in_enable,
    output wire out_risingEdge,
    output wire out_fallingEdge);
    
    reg lastState = 1'b0;
    
    // Sync with the rising edge clock, pipelining the signal.
    always @(posedge in_clock) begin
        if (in_reset) begin
            //Reset the pipeline.
            lastState <= 1'b0;
        end else begin
            if (in_enable) begin
                lastState <= in_signal;
            end
        end
    end
    
    //Detect the rising and falling edge of the signal.
    assign out_risingEdge  = in_signal & ~lastState;
    assign out_fallingEdge = ~in_signal & lastState;
endmodule
