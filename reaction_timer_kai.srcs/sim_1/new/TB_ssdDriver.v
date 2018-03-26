`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/18 14:21:11
// Design Name: 
// Module Name: TB_ssdDriver
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

`include "globalConstants.v"

module TB_ssdDriver;

    reg [31:0] digits = {`SSD_CHAR_2, `SSD_CHAR_9, `SSD_CHAR_4, `SSD_CHAR_1, `SSD_CHAR_MINUS, `SSD_CHAR_BLANK, `SSD_CHAR_0, `SSD_CHAR_9};
    reg [7:0] in_dots = 8'b0111_1111;
    reg clock = 0, clock_1kHz = 0;
    wire [6:0] digitExp;
    wire [7:0] digitSelector;
    wire digitDot;

    ssdDriver UUT(
        .in_digit7(digits[31:28]),
        .in_digit6(digits[27:24]),
        .in_digit5(digits[23:20]),
        .in_digit4(digits[19:16]),
        .in_digit3(digits[15:12]),
        .in_digit2(digits[11:8]),
        .in_digit1(digits[7:4]),
        .in_digit0(digits[3:0]),
        .in_dots(in_dots),
        .in_clock_1kHz_rising(clock),
        .in_clock(clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_digitExpression(digitExp),
        .out_digitDot(digitDot),
        .out_digitSelector(digitSelector));
    
    always begin
        #1 clock = ~clock;
    end
    
    always begin
        #5 clock_1kHz = ~clock_1kHz;
    end

endmodule
