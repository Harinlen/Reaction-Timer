`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/27 14:43:29
// Design Name: 
// Module Name: TB_audioPwmModem
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


module TB_audioPwmModem;

    reg clock = 1'b0;
    reg [7:0] sampleInput = 8'd65;
    wire pwmWave;

    audioPwmModem #(
        .PLAYING_CLOCK_THRESHOLD(2)
    ) UUT (
        .in_reset(1'b0),
        .in_enable(1'b1),
        .in_clock(clock),
        .in_audioSample(sampleInput),
        .out_audioPwmWave(pwmWave)
    );
    
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #20 sampleInput = 8'd128;
    end

endmodule
