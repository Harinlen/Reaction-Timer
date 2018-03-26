`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/19 00:17:59
// Design Name: 
// Module Name: TB_reactTimerCpu
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


module TB_reactTimerCpu;

    reg clock = 0;
    reg start = 0;
    reg test = 0;
    wire [15:0] leds;
    wire [3:0] numberDisplay [7:0];
    wire [7:0] ssdDots;
    wire [31:0] timeCounter;

    globalTime UUT_HELPER(
        .in_clock(clock),
        .out_time(timeCounter));

    reactTimerCpu #(
        .IDLE_ANIMATION_THRESHOLD(4),
        .PREPARE_COUNT_DOWN_THRESHOLD(4),
        .PREPARE_TEST_DELAY_TIME(10),
        .TEST_COUNTER_LIMITATION(60),
        .RESULT_BEST_FLASH_THRESHOLD(4),
        .RESULT_WAITING_COUNTS(30)
    ) UUT (
        .in_globalTime(timeCounter),
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .in_start(start),
        .in_test(test),
        .out_leds(leds),
        .out_ssdOutput({numberDisplay[7], numberDisplay[6], numberDisplay[5], numberDisplay[4],
                        numberDisplay[3], numberDisplay[2], numberDisplay[1], numberDisplay[0]}),
        .out_ssdDots(ssdDots)
    );
    
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #100 start = 1;
        #6 start = 0;
        #500 start = 1;
        #6 start = 0;
        #120 test = 1;
        #6 test = 0;
    end

endmodule
