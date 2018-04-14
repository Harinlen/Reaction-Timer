`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/14 21:39:28
// Design Name: 
// Module Name: TB_edgeDetector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_edgeDetector;

    reg clock = 1'b1;
    always begin
        #1 clock = ~clock;
    end
    
    wire source, rising, falling;
    clockDivider #(
        .THRESHOLD(6) // Half the freq of the raw clock
    ) UUT_Helper (
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_dividedClock(source));

    edgeDetector UUT(
        .in_signal(source),
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_risingEdge(rising),
        .out_fallingEdge(falling));

endmodule
