`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/04/03 22:10:58
// Design Name: VGA Display Text Mode Driver
// Module Name: vgaDriver
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to drive the VGA output to display the 
// text mode of DOS at 640x480 resolution.
// This driver works with the ASC16 standard font output. This module works with
// the VRAM module that would provide the output data with the VGA character input.
// This driver contains a double buffer for the character level data, which means
// that the video signal output won't be teared.
// 
// Dependencies: 
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vgaDriver(
    input wire         in_clock,
    input wire         in_reset,
    input wire         in_enable,
    input wire [0:127] in_charPixel,
    output reg [7:0]   out_charXPos = 8'd0,
    output reg [7:0]   out_charYPos = 8'd0,
    output wire        out_vgaR,
    output wire        out_vgaG,
    output wire        out_vgaB,
    output wire        out_vgaHs,
    output wire        out_vgaVs);
    
    reg [10:0] x_charPixelPos = 11'd0, x_charBasePos = 11'd0;
    reg [2:0] x_pixelCounter = 3'd0;
    reg [10:0] x_counter = 11'd0, y_counter = 11'd0;
    reg [0:127] currentCharPixel = 128'd0;
    
    // This piece of code works exactly as the clock divider,
    // but I want to save the resource. :)
    reg counter = 1'b0, clock_25MHz = 1'b0;
    always @(posedge in_clock) begin
        if (counter) begin
            clock_25MHz <= ~clock_25MHz;
        end
        counter <= ~counter;
    end
    
    // Create the edge detector.
    wire clock_25MHzRising;
    // 25MHz clock edge detector.
    edgeDetector clockEdge25MHz(
        .in_signal(clock_25MHz),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(clock_25MHzRising));
            
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the counter.
            x_counter <= 11'd0;
            y_counter <= 11'd0;
            // Reset the char request.
            out_charXPos <= 8'd0;
            out_charYPos <= 8'd0;
            // Reset the pixel counter.
            x_charPixelPos <= 11'd0;
            x_charBasePos <= 11'd0;
            x_pixelCounter <= 3'd0;
            // Reset current pixel.
            currentCharPixel <= 128'd0;
        end else begin
            if (clock_25MHzRising) begin
                //Move to next position.
                if (x_counter == 800) begin
                    // Back to left most.
                    x_counter <= 0;
                    //--------- Text Logic ----------
                    //     A new line comes.
                    // Reset the pixel counter to 0.
                    x_pixelCounter <= 3'd0;
                    // Reset the char X base pos. 
                    out_charXPos <= 0;
                    x_charPixelPos <= 11'd0;
                    //--------- Text Logic ----------
                    //Update the x base pos.
                    if (y_counter == 523) begin
                        // Back to top most.
                        y_counter <= 0;
                        //--------- Text Logic ----------
                        //     A to the bottom of the display.
                        x_charBasePos <= 0;
                        // Back to the first line.
                        out_charYPos <= 0;
                        //--------- Text Logic ----------
                    end else begin
                        // Increase veritical line.
                        y_counter <= y_counter + 1;
                        //--------- Text Logic ----------
                        //     To the next horizontal line
                        // Check the y counter is in the range.
                        if (y_counter < 34) begin
                            // Refresh current pixel.
                            currentCharPixel <= in_charPixel;
                        end else if (y_counter > 34 && y_counter < 514) begin
                            // Check char base pos.
                            if (x_charBasePos == 120) begin
                                //      Move to next line of character.
                                // Increase the char y position.
                                out_charYPos <= out_charYPos + 1;
                                // Back to first column.
                                x_charBasePos <= 0;
                            end else begin
                                // Increase a new line, update the current line.
                                x_charBasePos <= x_charBasePos + 8;
                            end
                        end
                        //--------- Text Logic ----------
                    end
                end else begin 
                    // Increase horizontal column.
                    x_counter <= x_counter + 1;
                    //--------- Text Logic ----------
                    //     A to the next veritical pixel.
                    // Check the x counter is in the rand.
                    if (x_counter < 142) begin
                        // Update the current char.
                        currentCharPixel <= in_charPixel;
                        // Reset the char pixel counter.
                        x_charPixelPos <= x_charBasePos;
                        x_pixelCounter <= 3'd0;
                    end else if (x_counter > 144 && x_counter < 784) begin
                        // Increase the pixel counter.
                        if (x_pixelCounter < 3'd7) begin
                            if (x_pixelCounter == 3'd4) begin
                                //      Move to next character.
                                out_charXPos <= out_charXPos + 1;
                            end
                            //      Move to next pixel.
                            // Simply increase the pixel counter.
                            x_pixelCounter <= x_pixelCounter + 3'd1;
                            // Increase the char pixel pos to update the pixel.
                            x_charPixelPos <= x_charPixelPos + 3'd1;
                        end else begin
                            //      Move to next line of column.
                            // Reset the pixel counter to 0.
                            x_pixelCounter <= 3'd0;
                            // Reset the char pixel counter.
                            x_charPixelPos <= x_charBasePos;
                            // Update the current char.
                            currentCharPixel <= in_charPixel;
                        end
                    end
                    //--------- Text Logic ----------
                end
            end
        end
    end
    
    // Set the display pixel
    wire pixelDisplay;
    assign pixelDisplay = currentCharPixel[x_charPixelPos] && (x_counter > 143 && x_counter < 783) && (y_counter > 34 && y_counter < 514);
    // RGB has the same output, we have only RGB support.
    assign out_vgaR = pixelDisplay;
    assign out_vgaG = pixelDisplay;
    assign out_vgaB = pixelDisplay;
    // Column sync with row.
    assign out_vgaHs = (x_counter > 95);
    // Row counter sync with the field.
    assign out_vgaVs = (y_counter > 1);

endmodule
