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
    
    reg [1:0] pipeline = 2'd0;
    
    // Sync with the rising edge clock, pipelining the signal.
    always @(posedge in_clock) begin
        if (in_reset) begin
            //Reset the pipeline.
            pipeline <= 2'b00;
        end else begin
            if (in_enable) begin
                //Save and shift the pipeline
                pipeline[0] <= in_signal;
                pipeline[1] <= pipeline[0];
            end
        end
    end
    
    //Detect the rising and falling edge of the signal.
    assign out_risingEdge  = (pipeline == 2'b01);
    assign out_fallingEdge = (pipeline == 2'b10);
endmodule
