`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/26 21:41:33
// Design Name: 
// Module Name: TB_divisionByTen
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


module TB_divisionByTen;

    reg [31:0] number = 32'd0;
    reg numberValid = 1'b0, clock = 1'b0;
    wire resultValid;
    wire [31:0] result;

    divisionByTen UUT(
        .in_number(number),
        .in_numberValid(numberValid),
        .in_reset(1'b0),
        .in_clock(clock),
        .in_enable(1'b1),
        .out_resultValid(resultValid),
        .out_result(result));
    
    always begin
        #1 clock = ~clock;
    end
    
    initial begin
        #5 number = 32'd60;
           numberValid = 1'b1;
        #4 numberValid = 1'b0;
        #20 number = 32'd166;
            numberValid = 1'b1;
        #4 numberValid = 1'b0;
    end

endmodule
