`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/28 00:28:14
// Design Name: 
// Module Name: TB_audioHintOutput
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


module TB_audioHintOutput;

    reg clock = 1'b0, playStart = 1'b0, playStop = 1'b0; 
    wire audioPwm;

    audioHintOutput #(
        .PLAYING_CLOCK_THRESHOLD(0)
    ) UUT (
        .in_100MHzClock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .in_startPlaying(playStart),
        .in_stopPlaying(playStop),
        .out_audioPwm(audioPwm)
    );
    
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #2 playStart = 1'b1;
    end

endmodule
