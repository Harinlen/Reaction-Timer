`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/17 19:21:00
// Design Name: 
// Module Name: TB_actionRetarder
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


module TB_actionRetarder;

    reg [31:0] delayCounts = 32'd32;
    reg clock = 0;
    reg reset = 1;
    reg enable = 1;
    reg pulseIn = 0;
    wire pulseOut;

    actionRetarder UUT(
        .in_delayCounts(delayCounts),
        .in_clock(clock),
        .in_reset(reset),
        .in_enable(enable),
        .in_pulseIn(pulseIn),
        .out_pulseOut(pulseOut));
       
    always begin
        #1 clock = ~clock;
    end
        
    initial begin
        #2 reset = 0;
        #6 pulseIn = 1;
        #3 pulseIn = 0;
        #6 pulseIn = 1; // This signal should be ignored.
        #3 pulseIn = 0;
    end

endmodule
