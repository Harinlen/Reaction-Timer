`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/18 17:08:31
// Design Name: 
// Module Name: TB_ssdAnimation
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


module TB_ssdAnimation;
    
    reg start = 0;
    reg clock = 0;
    wire busy, startRising;
    wire [3:0] numberDisplay [7:0];
    
    edgeDetector UUT_HELPER(
        .in_signal(start),
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_risingEdge(startRising));
    
    ssdAnimation #(
        .ANIME_CLOCK_THRESHOLD(4)
    ) UUT (
        .in_startRising(startRising),
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_busy(busy),
        .out_numberDisplay({numberDisplay[7], numberDisplay[6], numberDisplay[5], numberDisplay[4],
                            numberDisplay[3], numberDisplay[2], numberDisplay[1], numberDisplay[0]}));
        
    always begin
        #1 clock = ~clock;
    end 
    
    initial begin
        #8 start = 1;
    end

endmodule
