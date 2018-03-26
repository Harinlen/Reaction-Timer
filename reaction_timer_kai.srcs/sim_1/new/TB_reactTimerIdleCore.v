`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/18 11:11:57
// Design Name: 
// Module Name: TB_reactTimerIdleCore
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


module TB_reactTimerIdleCore;

    reg [27:0]  reactionTime = 28'd0;
    reg         reactionTimeValid = 0;
    reg         animeReset = 0;
    reg         clock = 0;
    wire [15:0] leds;
    wire [27:0] ssdOutput;
    wire [27:0] recordTime;
    wire [7:0]  ssdDots;
    
    reactTimerIdleCore UUT(
        .in_reactionTime(reactionTime),
        .in_reactionTimeValid(reactionTimeValid),
        .in_animeReset(animeReset),
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_bestTime(recordTime),
        .out_leds(leds),
        .out_ssdOutput(ssdOutput),
        .out_ssdDots(ssdDots));
        
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #1 animeReset = 1;
        #3 animeReset = 0;
        #2 reactionTime = 28'd56821426;
           reactionTimeValid = 1;
        #5 reactionTimeValid = 0;
        #8 reactionTime = 28'd36597210;
           reactionTimeValid = 1;
        #5 reactionTimeValid = 0;
        #8 reactionTime = 28'd95846214;
           reactionTimeValid = 1;
           
        
    end

endmodule
