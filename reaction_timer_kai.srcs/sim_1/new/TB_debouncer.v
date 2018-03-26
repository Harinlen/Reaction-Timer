`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/17 23:08:59
// Design Name: 
// Module Name: TB_debouncer
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


module TB_debouncer;
    
    reg clock = 0;
    reg enable = 0;
    reg reset = 0;
    reg buttonIn = 0;
    wire buttonOut;
    
    debouncer UUT(
        .in_clock(clock),
        .in_enable(enable), // Should be an lower freq clock.
        .in_reset(reset),
        .in_buttonIn(buttonIn),
        .out_buttonOut(buttonOut));
        
    always begin 
       #1 clock = ~clock; 
    end
    
    always begin
       #4 enable = ~enable;
    end
    
    initial begin
        #5 buttonIn = 1;
        #2 buttonIn = 0;
        #3 buttonIn = 1;
        #6 buttonIn = 0;
        #2 buttonIn = 1;
    end

endmodule
