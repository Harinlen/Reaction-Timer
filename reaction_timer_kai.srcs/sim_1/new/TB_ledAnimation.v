`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/18 11:11:57
// Design Name: 
// Module Name: TB_ledAnimation
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


module TB_ledAnimation;

    reg clock = 0;
    reg animeClock = 0;
    wire [15:0] ledOutputs;
    
    ledAnimation UUT(
        .in_clock(clock),    
        .in_animeClock(animeClock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_leds(ledOutputs));
        
    always begin
        #1 clock = ~clock;
    end
    
    always begin
        #4 animeClock = ~animeClock;
    end

endmodule
