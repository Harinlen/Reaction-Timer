`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/18 17:35:14
// Design Name: 
// Module Name: TB_reactTimerPrepareCore
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


module TB_reactTimerPrepareCore;

    reg clock = 0, start = 0;
    wire [31:0] timeCounter;
    wire [3:0] numberDisplay [7:0];
    wire [31:0] delay;
    wire busy;

    globalTime UUT_HELPER(
        .in_clock(clock),
        .out_time(timeCounter));

    reactTimerPrepareCore #(
        .COUNT_DOWN_CLOCK_THRESHOLD(4)
    ) UUT (
        .in_globalTime(timeCounter),
        .in_startRising(start),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .in_clock(clock),
        .out_busy(busy),
        .out_numberDisplay({numberDisplay[7], numberDisplay[6], numberDisplay[5], numberDisplay[4],
                            numberDisplay[3], numberDisplay[2], numberDisplay[1], numberDisplay[0]}),
        .out_delay(delay)
    );
    
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #8 start = 1;
        #5 start = 0;
        #520 start = 1;
        #5 start = 0;
        #60000 start = 1;
        #5 start = 0;
    end

endmodule
