`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/14 21:30:13
// Design Name: 
// Module Name: TB_delayDebouncer
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


module TB_delayDebouncer;
    
    reg reset=1'b0, enable=1'b1, clock=1'b1, signal=1'b0;
    wire debSignal;
    
    delayDebouncer UUT(
        .in_reset(reset),
        .in_enable(enable),
        .in_clock(clock),
        .in_signal(signal),
        .out_debouncedSignal(debSignal));
        
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #4 signal = 1'b1;
        #3 signal = 1'b0;
        #4 signal = 1'b1;
        #6 signal = 1'b0;
        #2 signal = 1'b1;
        #13 signal = 1'b0;
    end

endmodule
