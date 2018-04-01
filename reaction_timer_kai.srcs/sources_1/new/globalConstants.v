`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/17 17:20:37
// Design Name: Global Constants Definitions
// Module Name: globalConstants
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This file defines the constants used in this project.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Declare the valid or not.
`define OUTPUT_VALID        1'b1
`define OUTPUT_INVALID      1'b0

// Declare display chars.
`define SSD_CHAR_0          4'd0
`define SSD_CHAR_1          4'd1
`define SSD_CHAR_2          4'd2
`define SSD_CHAR_3          4'd3
`define SSD_CHAR_4          4'd4
`define SSD_CHAR_5          4'd5
`define SSD_CHAR_6          4'd6
`define SSD_CHAR_7          4'd7
`define SSD_CHAR_8          4'd8
`define SSD_CHAR_9          4'd9
`define SSD_CHAR_MINUS      4'd10
`define SSD_CHAR_BLANK      4'd11
`define SSD_CHAR_A          4'd12
`define SSD_CHAR_F          4'd13
`define SSD_CHAR_I          4'd14
`define SSD_CHAR_L          4'd15

// Special display data.
`define SSD_DISPLAY_BLANK   {`SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK}
`define SSD_DISPLAY_MINUS   {`SSD_CHAR_MINUS, `SSD_CHAR_MINUS, `SSD_CHAR_MINUS, `SSD_CHAR_MINUS, `SSD_CHAR_MINUS, `SSD_CHAR_MINUS, `SSD_CHAR_MINUS, `SSD_CHAR_MINUS}
`define SSD_DISPLAY_FAIL    {`SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_F,     `SSD_CHAR_A,     `SSD_CHAR_I,     `SSD_CHAR_L,     `SSD_CHAR_BLANK, `SSD_CHAR_BLANK}