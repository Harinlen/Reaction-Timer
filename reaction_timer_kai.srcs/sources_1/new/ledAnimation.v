`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/18 11:54:28
// Design Name: LED Animation Encoder
// Module Name: ledAnimation
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to shows a pre-written LED animations with
// a specific freq. The animation frames would be stored in an array.
// 
// Dependencies: 
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ledAnimation(
    input wire in_clock,
    input wire in_animeClock,
    input wire in_reset,
    input wire in_enable,
    output reg [15:0] out_leds = 16'd0);
    
    // Animation data
    localparam FRAME_COUNTS = 8'd17;
    reg [15:0] FRAMES [FRAME_COUNTS - 1 : 0];
    // Animation playing frame.
    reg [7:0] currentFrame = 8'd0;
    wire animeClockRising;
    
    // Initial the frame data.
    // Due to the Verilog syntax, this is the only
    // way to inital an array.
    initial begin
        FRAMES[ 0] = 16'b0000_0000_0000_0000;
        FRAMES[ 1] = 16'b0000_0001_1000_0000;
        FRAMES[ 2] = 16'b0000_0011_1100_0000;
        FRAMES[ 3] = 16'b0000_0111_1110_0000;
        FRAMES[ 4] = 16'b0000_1111_1111_0000;
        FRAMES[ 5] = 16'b0001_1111_1111_1000;
        FRAMES[ 6] = 16'b0011_1111_1111_1100;
        FRAMES[ 7] = 16'b0111_1111_1111_1110;
        FRAMES[ 8] = 16'b1111_1111_1111_1111;
        FRAMES[ 9] = 16'b1111_1110_0111_1111;
        FRAMES[10] = 16'b1111_1100_0011_1111;
        FRAMES[11] = 16'b1111_1000_0001_1111;
        FRAMES[12] = 16'b1111_0000_0000_1111;
        FRAMES[13] = 16'b1110_0000_0000_0111;
        FRAMES[14] = 16'b1100_0000_0000_0011;
        FRAMES[15] = 16'b1000_0000_0000_0001;
        FRAMES[16] = 16'b0000_0000_0000_0000;
    end
    
    edgeDetector animeClockDetector(
        .in_signal(in_animeClock),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(animeClockRising));
    
    always @(posedge in_clock) begin
        // Check reset signal.
        if (in_reset) begin
            // Reset the output data.
            out_leds <= 16'd0;
            // Reset the current animation frame pointer.
            currentFrame <= 8'd0;
        end else begin
            if (in_enable) begin
                // Check the animation clock.
                if (animeClockRising) begin
                    // Check current frame reach the boundary.
                    if (currentFrame < FRAME_COUNTS - 1) begin
                        currentFrame <= currentFrame + 1;
                    end else begin
                        currentFrame <= 0;
                    end
                end
                // Update the output signal.
                out_leds <= FRAMES[currentFrame];
            end
        end
    end
    
endmodule
