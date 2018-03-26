`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/17 22:28:17
// Design Name: 
// Module Name: TB_randLcg
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


module TB_randLcg;

    reg [31:0] seed = 0;
    reg seedReady = 0, next = 0, clock = 0, reset = 0, enable = 1;
    wire [31:0] randOut;
    wire [31:0] globalTime;
    wire busy;
    
    globalTime UUT_HELPER (
        .in_clock(clock),
        .out_time(globalTime));

    randLcg UUT(
        .in_globalTime(globalTime),
        .in_seed(seed),
        .in_seedReady(seedReady),
        .in_next(next),
        .in_clock(clock),
        .in_reset(reset),
        .in_enable(enable),
        .out_data(randOut),
        .out_busy(busy));
       
    always begin
        #1 clock = ~clock;
    end
        
    initial begin
        #2 seedReady = 1;
        #3 seedReady = 0;
        #2 next = 1;
        #3 next = 0;
        #5 next = 1;
        #3 next = 0;
        #5 next = 1;
        #3 next = 0;
        #5 next = 1;
        #3 next = 0;        
    end

endmodule
