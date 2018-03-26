`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/17 19:57:46
// Design Name: 
// Module Name: TB_clockDivider
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


module TB_clockDivider;

    reg clock = 0;
    reg reset = 0;
    reg enable = 1;
    wire outClock;

    clockDivider #(
        .THRESHOLD(2) // Half the freq of the raw clock
    ) UUT (
        .in_clock(clock),
        .in_reset(reset),
        .in_enable(enable),
        .out_dividedClock(outClock));

    always begin
        #1 clock = ~clock;
    end

endmodule
