`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/29 00:55:39
// Design Name: 
// Module Name: TB_randMt19937
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


module TB_randMt19937;

    reg clock = 1'b0, seedReady = 1'b0, next = 1'b0;
    wire [31:0] outData;
    wire outBusy;

    randMt19937 UUT(
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .in_seed(32'd4357),
        .in_seedReady(seedReady),
        .in_next(next),
        .out_data(outData),
        .out_busy(outBusy));
       
    always begin
        #1 clock = ~clock;
    end
        
    initial begin
        #2 seedReady = 1'b1;
        #5 seedReady = 1'b0;
        #3 next = 1'b1;
    end

endmodule
