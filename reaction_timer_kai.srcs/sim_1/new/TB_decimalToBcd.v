`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/26 15:55:34
// Design Name: 
// Module Name: TB_decimalToBcd
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


module TB_decimalToBcd;

    reg clock=0, numValid=0;
    reg [27:0] number=0;
    wire bcdValid;
    wire [31:0] bcd;

    decimalToBcd UUT(
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .in_number(number),
        .in_numberValid(numValid),
        .out_bcdValid(bcdValid),
        .out_bcd(bcd));
        
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        number = 28'd7652018;
        #1 numValid = 1;
        #5 numValid = 0;
    end

endmodule
