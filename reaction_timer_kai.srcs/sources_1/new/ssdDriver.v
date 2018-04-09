`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/18 14:07:57
// Design Name: Seven-Segments Display Driver
// Module Name: ssdDriver
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to output values to a 8-digit seven segement
// display. By providing the encode of the character, this module would display the 
// data to the hardware.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module ssdDriver(
    input wire [3:0] in_digit7,
    input wire [3:0] in_digit6,
    input wire [3:0] in_digit5,
    input wire [3:0] in_digit4,
    input wire [3:0] in_digit3,
    input wire [3:0] in_digit2,
    input wire [3:0] in_digit1,
    input wire [3:0] in_digit0,
    input wire [7:0] in_dots,
    input wire       in_clock_1kHz_rising,
    input wire       in_clock,
    input wire       in_reset,
    input wire       in_enable,
    output reg [6:0] out_digitExpression = 7'b1111111,
    output reg       out_digitDot        = 1'b1,
    output reg [7:0] out_digitSelector   = 8'b11111111);
    
    reg [3:0] displayDigit = `SSD_CHAR_BLANK;
    reg [2:0] displayIndex = 3'd0;
    
    // Count the display output index.
    always @(posedge in_clock) begin
        // Check for reset.
        if (in_reset) begin
            displayIndex <= 3'd0;
            displayDigit <= `SSD_CHAR_BLANK;
        end else begin
            //Count when 1kHz clock is on its rising edge.
            if (in_clock_1kHz_rising) begin
                // No need to check boundary, it will overflow back to 0.
                displayIndex <= displayIndex + 3'd1;
            end
        end
        //Update display digit selector..
        out_digitSelector <= ~(8'd1 << displayIndex);
        //Update the digit dot data.
        out_digitDot <= (in_dots & (1 << displayIndex)) > 0;
        //Update the output digit.
        case(displayIndex)
            3'd0: displayDigit <= in_digit0;
            3'd1: displayDigit <= in_digit1;
            3'd2: displayDigit <= in_digit2;
            3'd3: displayDigit <= in_digit3;
            3'd4: displayDigit <= in_digit4;
            3'd5: displayDigit <= in_digit5;
            3'd6: displayDigit <= in_digit6;
            3'd7: displayDigit <= in_digit7;
        endcase
    end
    
    // This is just a simple decoder, no need to sync with clock.
    always @(*) begin
        if (in_reset || (~in_enable)) begin
            // For reset and disable, display invisible char.
            out_digitExpression = 7'b1111111;
        end else begin
            // Check the current number of display index.
            case (displayDigit)
                //0-9: digits
                // Bit expression:
                //  -   6
                // | | 1 5
                //  -   0
                // | | 2 4
                //  -   3
                //                               Bit Index 6543210
                `SSD_CHAR_0     : out_digitExpression = 7'b0000001;
                `SSD_CHAR_1     : out_digitExpression = 7'b1001111;
                `SSD_CHAR_2     : out_digitExpression = 7'b0010010;
                `SSD_CHAR_3     : out_digitExpression = 7'b0000110;
                `SSD_CHAR_4     : out_digitExpression = 7'b1001100;
                `SSD_CHAR_5     : out_digitExpression = 7'b0100100;
                `SSD_CHAR_6     : out_digitExpression = 7'b0100000;
                `SSD_CHAR_7     : out_digitExpression = 7'b0001111;
                `SSD_CHAR_8     : out_digitExpression = 7'b0000000;
                `SSD_CHAR_9     : out_digitExpression = 7'b0000100;
                `SSD_CHAR_MINUS : out_digitExpression = 7'b1111110;
                `SSD_CHAR_BLANK : out_digitExpression = 7'b1111111;
                `SSD_CHAR_F     : out_digitExpression = 7'b0111000;
                `SSD_CHAR_A     : out_digitExpression = 7'b0001000;
                `SSD_CHAR_I     : out_digitExpression = 7'b1111001;
                `SSD_CHAR_L     : out_digitExpression = 7'b1110001;
                default         : out_digitExpression = 7'b1111111; // As invisible char.
            endcase 
        end
    end
    
endmodule
