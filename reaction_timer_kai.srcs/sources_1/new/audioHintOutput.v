`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2018 13:33:49
// Design Name: 
// Module Name: audioHintOutput
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module is designed to output the audio hint signal. The audio
// output would be a mono channel sine wave. This audio would be played during the
// test phrase until the tester press the button. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module audioHintOutput #(
    parameter integer PLAYING_CLOCK_THRESHOLD = 10_000_0 
)(
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    input wire        in_startPlaying,
    input wire        in_stopPlaying,
    output wire       out_audioPwm);
    
    // The state of audio playing module.
    /*
     * STATE_IDLE: Wait for the input signal from start playing.
     */
    localparam STATE_IDLE = 1'b0;
    /*
     * STATE_PLAYING: Playing the pre-written sine wave until the stop playing 
     * signal rising.
     */
    localparam STATE_PLAYING = 1'b1;
    
    reg state = STATE_IDLE;
    
    // Sine wave 1024 sample.
    reg [15:0] sineSample [1023:0];
    
    initial begin
        $readmemh("sineWaveTable", sineSample);
    end
    
    // We have to detect the rising of start playing.
    wire startPlayingRising;
    edgeDetector startPlayingDetector(
        .in_signal(in_startPlaying),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(startPlayingRising));
        
    wire stopPlayingRising;
    edgeDetector stopPlayingDetector(
        .in_signal(in_stopPlaying),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(stopPlayingRising));

    // Create a clock for output playing signal.
    wire playingClock, playingClockRising;
    clockDivider #(
        .THRESHOLD(PLAYING_CLOCK_THRESHOLD)
    ) clockPlayingInterval (
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_dividedClock(playingClock));
        
    edgeDetector playingIntervalRising(
        .in_signal(playingClock),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(playingClockRising));
    
    reg [9:0] currentSampleIndex = 10'd0;
    reg [15:0] currentSample = 16'd0;
        
    always @(posedge in_clock) begin
        // Check reset state.
        if (in_reset) begin
            // Reset the state.
            state <= STATE_IDLE;
            // Reset the output.
            currentSampleIndex <= 10'd0;
            currentSample <= 16'd0;
        end else begin
            if (in_enable) begin
                // Check the current state.
                case (state)
                    STATE_IDLE: begin
                        // Waiting for start playing rising.
                        if (startPlayingRising) begin
                            // Move to playing state.
                            state <= STATE_PLAYING;
                            // Reset the sample index to the first sample.
                            currentSampleIndex <= 10'd0;
                        end
                    end
                    STATE_PLAYING: begin
                        // Check the stop playing rising.
                        if (stopPlayingRising) begin
                            // Move to idle state.
                            state <= STATE_IDLE;
                        end else begin
                            // Output the audio signal.
                            if (playingClockRising) begin
                                currentSampleIndex <= currentSampleIndex + 1;
                            end
                            // The output sample is now determined.
                            currentSample <= sineSample[currentSampleIndex];
                        end
                    end
                endcase
            end
        end
    end
    
    audioPwmModem #(
        .PLAYING_CLOCK_THRESHOLD(PLAYING_CLOCK_THRESHOLD) 
    ) audioHintPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .in_audioSample(currentSample),
        .out_audioPwmWave(out_audioPwm));
    
endmodule
