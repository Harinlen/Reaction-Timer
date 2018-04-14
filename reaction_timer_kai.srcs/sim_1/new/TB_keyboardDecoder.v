`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/14 21:52:59
// Design Name: 
// Module Name: TB_keyboardDecoder
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


module TB_keyboardDecoder;

    reg clock = 1'b1;
    
    initial begin
        forever #1 clock = ~clock;
    end
    
    reg [7:0] keycode = 8'h16;
    wire [3:0] red, green, blue;

    keyboardDecoder UUT(
        .in_reset(1'b0),
        .in_enable(1'b1),
        .in_clock(clock),
        .in_keycode(keycode),
        .in_keycodeValid(1'b1),
        .out_redColor(red),
        .out_greenColor(green),
        .out_blueColor(blue));

    initial begin
        #8 keycode = 8'hF0;
        #2 keycode = 8'h25;
        #10 keycode = 8'h2E;
        #11 keycode = 8'hE1;
    end

endmodule
