`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/03 22:04:38
// Design Name: 
// Module Name: TB_asc16Font
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


module TB_asc16Font;
    
    reg [7:0] ascii;
    wire [127:0] charMap;
    
    asc16Font UUT(
        .in_charIndex(ascii),
        .out_bitmap(charMap)
    );
    
    initial begin
        #5 ascii = 65;
        #5 ascii = 67;
        #5 ascii = 120;
        #5 ascii = 127;
    end

endmodule
