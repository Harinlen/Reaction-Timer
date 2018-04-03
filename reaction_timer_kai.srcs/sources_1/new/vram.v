`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/03 22:24:00
// Design Name: 
// Module Name: vram
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

module vram(
    input wire         in_clock,
    input wire         in_reset,
    input wire         in_enable,
    input wire [7:0]   in_updateXPos,
    input wire [7:0]   in_updateYPos,
    input wire [7:0]   in_updateCharAscii,
    input wire         in_update,
    input wire [7:0]   in_charXPos,
    input wire [7:0]   in_charYPos,
    output reg [0:127] out_charBitmap = 128'd0);
    
    // Memory for saving all the characters.
    // 80 x 30
    reg [7:0] displayAsciiMaps [0:79][0:29];
    reg [7:0] i = 8'd0, j = 8'd0, currentAscii = 8'd0;
    wire [0:127] fontResult;
    
    // Embedded the ASCII chars.
    asc16Font vramAsciiFont(
        .in_charIndex(currentAscii),
        .out_bitmap(fontResult));
    
    initial begin
        // Reset the maps.
        for(i = 8'd0; i < 8'd80; i = i+1) begin
            for(j = 8'd0; j < 8'd30; j = j+1) begin
                // Reset the map.
                displayAsciiMaps[i][j] = 8'd0;
            end
        end
        displayAsciiMaps[0][0] = `ASC_CHAR_A;
        displayAsciiMaps[0][1] = `ASC_CHAR_B;
        displayAsciiMaps[0][2] = `ASC_CHAR_C;
        displayAsciiMaps[0][3] = `ASC_CHAR_D;
        displayAsciiMaps[0][4] = `ASC_CHAR_E;
        displayAsciiMaps[0][5] = `ASC_CHAR_F;
        displayAsciiMaps[0][6] = `ASC_CHAR_G;
    end
    
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the output.
            out_charBitmap <= 128'd0;
            // Reset the cache.
            currentAscii <= 8'd0;
        end else begin
            if (in_enable) begin
                // Check char update.
                if (in_update) begin
                    // Apply the character update.
                    displayAsciiMaps[in_updateXPos][in_updateYPos] <= in_updateCharAscii;
                end
                // Update the out char bitmap.
                currentAscii <= displayAsciiMaps[in_charXPos][in_charYPos];
                // Update the output data.
                out_charBitmap <= fontResult;
            end
        end
    end
    
endmodule
