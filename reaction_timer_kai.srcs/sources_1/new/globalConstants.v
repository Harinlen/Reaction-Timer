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

// ASCII Characters.
`define ASC_CHAR_SPACE      8'd32
`define ASC_CHAR_DQUOT      8'd34
`define ASC_CHAR_QUOTE      8'd39
`define ASC_CHAR_PLUS       8'd43
`define ASC_CHAR_MINUS      8'd45
`define ASC_CHAR_DOT        8'd46
`define ASC_CHAR_SLASH      8'd47
`define ASC_CHAR_0          8'd48
`define ASC_CHAR_1          8'd49
`define ASC_CHAR_2          8'd50
`define ASC_CHAR_3          8'd51
`define ASC_CHAR_4          8'd52
`define ASC_CHAR_5          8'd53
`define ASC_CHAR_6          8'd54
`define ASC_CHAR_7          8'd55
`define ASC_CHAR_8          8'd56
`define ASC_CHAR_9          8'd57
`define ASC_CHAR_COLON      8'd58
`define ASC_CHAR_A          8'd65
`define ASC_CHAR_B          8'd66
`define ASC_CHAR_C          8'd67
`define ASC_CHAR_D          8'd68
`define ASC_CHAR_E          8'd69
`define ASC_CHAR_F          8'd70
`define ASC_CHAR_G          8'd71
`define ASC_CHAR_H          8'd72
`define ASC_CHAR_I          8'd73
`define ASC_CHAR_J          8'd74
`define ASC_CHAR_K          8'd75
`define ASC_CHAR_L          8'd76
`define ASC_CHAR_M          8'd77
`define ASC_CHAR_N          8'd78
`define ASC_CHAR_O          8'd79
`define ASC_CHAR_P          8'd80
`define ASC_CHAR_Q          8'd81
`define ASC_CHAR_R          8'd82
`define ASC_CHAR_S          8'd83
`define ASC_CHAR_T          8'd84
`define ASC_CHAR_U          8'd85
`define ASC_CHAR_V          8'd86
`define ASC_CHAR_W          8'd87
`define ASC_CHAR_X          8'd88
`define ASC_CHAR_Y          8'd89
`define ASC_CHAR_Z          8'd90
`define ASC_CHAR_LMBRA      8'd91
`define ASC_CHAR_RMBRA      8'd93
`define ASC_CHAR_a          8'd97
`define ASC_CHAR_b          8'd98
`define ASC_CHAR_c          8'd99
`define ASC_CHAR_d          8'd100
`define ASC_CHAR_e          8'd101
`define ASC_CHAR_f          8'd102
`define ASC_CHAR_g          8'd103
`define ASC_CHAR_h          8'd104
`define ASC_CHAR_i          8'd105
`define ASC_CHAR_j          8'd106
`define ASC_CHAR_k          8'd107
`define ASC_CHAR_l          8'd108
`define ASC_CHAR_m          8'd109
`define ASC_CHAR_n          8'd110
`define ASC_CHAR_o          8'd111
`define ASC_CHAR_p          8'd112
`define ASC_CHAR_q          8'd113
`define ASC_CHAR_r          8'd114
`define ASC_CHAR_s          8'd115
`define ASC_CHAR_t          8'd116
`define ASC_CHAR_u          8'd117
`define ASC_CHAR_v          8'd118
`define ASC_CHAR_w          8'd119
`define ASC_CHAR_x          8'd120
`define ASC_CHAR_y          8'd121
`define ASC_CHAR_z          8'd122
`define ASC_CHAR_VERBR      8'd124
`define ASC_CHAR_TICK       8'd251

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