`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/18 16:33:31
// Design Name: Seven Segment Display Animation Encoder
// Module Name: ssdAnimation
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is design to show the animation of count down.
// It would maximum supports for 16 frames, but now only 5 of them are using.
// 
// Dependencies: 
//    - clockDivider
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module ssdAnimation #(
    parameter integer ANIME_CLOCK_THRESHOLD = 50_000_000
)(
    input wire          in_startRising,
    input wire          in_clock,
    input wire          in_reset,
    input wire          in_enable,
    output wire         out_busy,
    output reg [31:0]   out_numberDisplay = `SSD_DISPLAY_BLANK);
    
    // Animation frames.
    localparam FRAME_COUNTS = 4;
    reg [31:0] FRAMES [FRAME_COUNTS - 1:0];
    reg [3:0] currentFrame = 8'd0;
    
    // Inner busy state.
    localparam STATE_IDLE = 1'b0;
    localparam STATE_PLAYING = 1'b1;
    // Initial state is IDLE.
    reg state = STATE_IDLE;
    
    wire animeClock, animeClockRising;
    
    // Prepare for its own animation clock.
    clockDivider #(
       .THRESHOLD(ANIME_CLOCK_THRESHOLD)
    ) clock1Hz (
       .in_clock(in_clock),
       .in_reset(in_reset | ~state),
       .in_enable(in_enable),
       .out_dividedClock(animeClock));
    
    // Animation clock edge detector. 
    edgeDetector animeClockDetector(
        .in_signal(animeClock),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(animeClockRising));
    
    initial begin
        FRAMES[0] = `SSD_DISPLAY_MINUS;
        FRAMES[1] = {`SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_3};
        FRAMES[2] = {`SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_2};
        FRAMES[3] = {`SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_BLANK, `SSD_CHAR_1};
    end
    
    always @(posedge in_clock) begin
        // Check reset signal.
        if (in_reset) begin
            // Reset the current frame.
            currentFrame <= 8'd0;
            state <= STATE_IDLE;
        end else begin
            if (in_enable) begin
                // Check the current state.
                if (state) begin
                    // PLAYING state.
                    // Detect for the animation clock rising.
                    if (animeClockRising) begin
                        if (currentFrame < FRAME_COUNTS - 1) begin
                            // Increase the index.
                            currentFrame <= currentFrame + 1;
                            // Output the frame data.
                            out_numberDisplay <= FRAMES[currentFrame + 1];
                        end else begin
                            // No more busy.
                            state <= STATE_IDLE;
                            // Reset the number display.
                            out_numberDisplay <= `SSD_DISPLAY_BLANK;
                        end
                    end
                end else begin
                    // IDLE state.
                    // Waiting for start signal.
                    if (in_startRising) begin
                        state <= STATE_PLAYING;
                        // Reset the animation parameters.
                        currentFrame <= 8'd0;
                        // Output the frame data.
                        out_numberDisplay <= FRAMES[0];
                    end
                end
            end
        end
    end
    
    // Output busy state.
    assign out_busy = (state == STATE_PLAYING);
    
endmodule
