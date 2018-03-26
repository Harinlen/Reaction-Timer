`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2018 14:49:46
// Design Name: 
// Module Name: audioPwmModem
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


module audioPwmModem #(
    parameter integer PLAYING_CLOCK_THRESHOLD = 10_000_0 
)(
    input wire        in_reset,
    input wire        in_enable,
    input wire        in_clock,
    input wire [15:0] in_audioSample,
    output reg        out_audioPwmWave = 1'b0);
    
    // Prepare the accumulator for the PWM signal.
    reg [15:0] accumulator = 16'd0;
    reg [15:0] lastAudioSample = 16'd0;
    
    // Generate the sample counting clock
    wire sampleCountClock, sampleCountClockRising;
    clockDivider #(
            .THRESHOLD(PLAYING_CLOCK_THRESHOLD >> 4)
        ) clockPlayingInterval (
            .in_clock(in_clock),
            .in_reset(in_reset),
            .in_enable(in_enable),
            .out_dividedClock(sampleCountClock));

    // Detect the counting clock rising.
    edgeDetector playingIntervalRising(
            .in_signal(sampleCountClock),
            .in_clock(in_clock),
            .in_reset(in_reset),
            .in_enable(in_enable),
            .out_risingEdge(sampleCountClockRising));
    
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the accmulator.
            accumulator <= 16'd0;
            // Reset the pwm data.
            out_audioPwmWave <= 1'b0;
        end else begin
            if (in_enable) begin
                // Check the accumulator number.
                if (accumulator == 16'd0) begin
                    // Update for last audio sample.
                    lastAudioSample <= in_audioSample;
                    // Update the pwm.
                    out_audioPwmWave <= (in_audioSample > 16'd0);
                end else begin
                    // Check for whether we should count.
                    if (sampleCountClockRising) begin
                        accumulator <= accumulator + 1;
                    end
                    // Update the pwm output.
                    out_audioPwmWave <= accumulator < lastAudioSample;
                end
            end
        end
    end
    
endmodule
