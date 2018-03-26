`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/18 20:54:32
// Design Name: 
// Module Name: TB_reactTimerTestCore
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


module TB_reactTimerTestCore;

    reg [31:0] delay = 3;
    reg start = 0, testButton = 0, clock = 0;
    wire resultValid, timeout;
    wire [27:0] result;
    wire [15:0] leds;

    reactTimerTestCore UUT(
        .in_delay(delay),
        .in_start(start),
        .in_enable(1'b1),
        .in_reset(1'b0),
        .in_testButton(testButton),
        .in_clock(clock),
        .out_resultValid(resultValid),
        .out_timeout(timeout),
        .out_result(result),
        .out_leds(leds));
       
    always begin
        #1 clock = ~clock;
    end 
        
    initial begin
        #2 start = 1;
        #5 start = 0;
        #80 testButton = 1;
        #20 testButton = 0;
        #80 testButton = 1;
        #20 testButton = 0;
    end

endmodule
