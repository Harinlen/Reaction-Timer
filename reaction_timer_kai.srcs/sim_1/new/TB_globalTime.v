`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/17 22:10:52
// Design Name: 
// Module Name: TB_globalTime
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


module TB_globalTime;

    reg clock = 0;
    wire [31:0] count;
    
    globalTime UUT(
        .in_clock(clock),
        .out_time(count));
        
    always begin
        #5 clock = ~clock;
    end

endmodule
