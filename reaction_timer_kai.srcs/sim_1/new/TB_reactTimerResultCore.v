`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/18 23:23:10
// Design Name: 
// Module Name: TB_reactTimerResultCore
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


module TB_reactTimerResultCore;

    reg [27:0] testResult = 28'd86523140;
    reg [27:0] bestResult = 28'd0;
    reg testResultValid = 0, clock = 0;
    wire [3:0] numberDisplay [7:0];
    wire [7:0] ssdDots;
    wire busy;

    reactTimerResultCore #(
        .BEST_FLASH_THRESHOLD(4),
        .WAITING_COUNTS(30)
    ) UUT (
        .in_testResult(testResult),
        .in_bestResult(bestResult),
        .in_testTimeout(1'b0),
        .in_testResultValid(testResultValid),
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_busy(busy),
        .out_ssdNumberDisplay({numberDisplay[7], numberDisplay[6], numberDisplay[5], numberDisplay[4],
                               numberDisplay[3], numberDisplay[2], numberDisplay[1], numberDisplay[0]}),
        .out_ssdDots(ssdDots)
    );
    
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #5 testResultValid = 1;
        #20 testResultValid = 0;
        #250 testResultValid = 1;
             bestResult = 28'd86523140;
             testResult = 28'd23147905;
        #20 testResultValid = 0;
        #250 testResultValid = 1;
             bestResult = 28'd23147905;
             testResult = 28'd57489321;
        #20 testResultValid = 0;
    end

endmodule
