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

    // Inputs
    reg clk = 0;
    reg rst = 0;
    reg en = 1;
    reg [7:0] current_test = 0;
    
    reg [31:0] seed_val = 0;
    reg seed_start = 0;
    reg output_axis_tready = 0;
    
    // Outputs
    wire [31:0] output_axis_tdata;
    wire busy;
    
    randMt19937 UUT (
        .in_globalTime(32'd5489),
        .in_clock(clk),
        .in_reset(rst),
        .in_enable(en),
        .out_data(output_axis_tdata),
        .in_next(output_axis_tready),
        .in_seed(seed_val),
        .in_seedReady(seed_start),
        .out_busy(busy)
    );
    
    initial begin
        forever #1 clk = ~clk;
    end
    
    initial begin
        #5 output_axis_tready = 1;
        #3 output_axis_tready = 0;
        #41000; output_axis_tready = 1;
        #3; output_axis_tready = 0;
        #5; output_axis_tready = 1;
        #3; output_axis_tready = 0;
        #5; output_axis_tready = 1;
        #3; output_axis_tready = 0;
        #5; output_axis_tready = 1;
        #3; output_axis_tready = 0;
        #5; output_axis_tready = 1;
        #3; output_axis_tready = 0;
        #5; output_axis_tready = 1;
        #3; output_axis_tready = 0;
    end

endmodule
