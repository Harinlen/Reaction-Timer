`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/17 23:45:30
// Design Name: 
// Module Name: TB_latchDebouncer
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


module TB_latchDebouncer;

    reg clock = 0;
    reg enable = 0;
    reg reset = 0;
    reg buttonIn = 0;
    wire buttonOut;
    
    latchDebouncer #(
        .INTERVAL(15)
    ) UUT (
        .in_clock(clock),
        .in_enable(1'b1),
        .in_reset(reset),
        .in_buttonIn(buttonIn),
        .out_buttonOut(buttonOut));

    always begin 
       #1 clock = ~clock; 
    end
    
    initial begin
        #5 buttonIn = 1;
        #2 buttonIn = 0;
        #3 buttonIn = 1;
        #6 buttonIn = 0;
        #2 buttonIn = 1;
    end

endmodule
