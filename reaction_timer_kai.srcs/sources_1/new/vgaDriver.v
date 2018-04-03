`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/03 22:10:58
// Design Name: 
// Module Name: vgaDriver
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
    
    reg [7:0] x_charPixelPos = 8'd0, x_charBasePos = 8'd0, x_pixelCounter = 8'd0;
    reg [10:0] x_counter = 11'd0, y_counter = 11'd0;
    reg isPixelOn = 1'b1;
    
    // 25MHz clock.
    wire clock_25MHz, clock_25MHzRising;
    clockDivider #(
        .THRESHOLD(4)
    ) clock25MHz (
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_dividedClock(clock_25MHz));
    
    // Create the edge detector.
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
        end else begin
            //Move to next position.
            if (x_counter == 800) begin
                if (clock_25MHzRising) begin
                    // Back to left most.
                    x_counter <= 0;
                end
                if (y_counter == 521) begin
                    if (clock_25MHzRising) begin
                        // Back to top most.
                        y_counter <= 0;
                        x_charBasePos <= 0;
                        // Back to the first line.
                        out_charXPos <= 0;
                        out_charYPos <= 0;
                    end
                end
                else begin
                    if (clock_25MHzRising) begin
                        // Increase veritical line.
                        y_counter <= y_counter + 1;
                        // Check char base pos.
                        if (x_charBasePos==120) begin
                            // Back to first line.
                            x_charBasePos <= 0;
                            // Increase the line.
                            out_charXPos <= 0;    
                            out_charYPos <= out_charYPos + 1; 
                        end else begin
                            // Increase a new line.
                            x_charBasePos <= x_charBasePos + 8;
                        end
                    end
                end
            end else begin 
                if (clock_25MHzRising) begin
                    // Increase horizontal column.
                    x_counter <= x_counter + 1;
                    // Increase the pixel counter.
                    if (x_pixelCounter == 7) begin
                        // Reset the pixel counter to 0.
                        x_pixelCounter <= 8'd0;
                        // Reset the char pixel counter.
                        x_charPixelPos <= x_charBasePos;
                        // Increase the char index.
                        out_charXPos <= out_charXPos + 1;
                    end else begin
                        // Increase the counter.
                        x_pixelCounter <= x_pixelCounter + 8'd1;
                        // Increase the char pixel pos.
                        x_charPixelPos <= x_charPixelPos + 8'd1;
                    end
                end
            end
        end
    end
    
    // Set the display pixel
    wire pixelDisplay;
    assign pixelDisplay = in_charPixel[x_charPixelPos] && (x_counter > 151 && x_counter < 791) && (y_counter > 36 && y_counter < 516);
    // RGB has the same output, we have only RGB support.
    assign out_vgaR = pixelDisplay;
    assign out_vgaG = pixelDisplay;
    assign out_vgaB = pixelDisplay;
    // Column sync with row.
    assign out_vgaHs = (x_counter < 8 || x_counter > 103);
    // Row counter sync with the field.
    assign out_vgaVs = (y_counter < 2 || y_counter > 3);
    
endmodule
