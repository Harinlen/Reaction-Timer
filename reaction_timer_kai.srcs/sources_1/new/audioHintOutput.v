`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 22.03.2018 13:33:49
// Design Name: Audio Hint Signal Output
// Module Name: audioHintOutput
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to output the audio hint signal. The audio
// output would be a mono channel sine wave. This audio would be played during the
// test phrase until the tester press the button. 
// 
// Dependencies: 
//    - edgeDetector
//    - audioPwmModem
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module audioHintOutput #(
    parameter integer PLAYING_CLOCK_THRESHOLD = 1000
)(
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    input wire        in_startPlaying,
    input wire        in_stopPlaying,
    output reg        out_audioSd = 1'b1,
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
    // Initial the state to IDLE state.
    reg state = STATE_IDLE;
    
    /*
     * Tricks: an h80 in 256 bits PWM performs exactly as a sine wave.
     */
    localparam [7:0] SINE_WAVE_SAMPLE = 8'h80;
    
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
    
    reg [7:0] currentSample = SINE_WAVE_SAMPLE;
    wire increaseSampleIndex;
    
    reg pwmModemEnable = 1'b0;
    
    audioPwmModem #(
        .PLAYING_CLOCK_THRESHOLD(PLAYING_CLOCK_THRESHOLD) 
    ) audioHintPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable & pwmModemEnable),
        .in_clock(in_clock),
        .in_audioSample(currentSample),
        .out_switchSample(increaseSampleIndex),
        .out_audioPwmWave(out_audioPwm));

    always @(posedge in_clock) begin
        // Check reset state.
        if (in_reset) begin
            // Reset the state.
            state <= STATE_IDLE;
            // Reset the output.
            pwmModemEnable <= 1'b0;
        end else begin
            if (in_enable) begin
                // Check the current state.
                case (state)
                    STATE_IDLE: begin
                        // Waiting for start playing rising.
                        if (startPlayingRising) begin
                            // Move to playing state.
                            state <= STATE_PLAYING;
                            // Enable the modem.
                            pwmModemEnable <= 1'b1;
                        end else begin
                            // Disable modem output.
                            pwmModemEnable <= 1'b0;
                        end
                    end
                    STATE_PLAYING: begin
                        // Check the stop playing rising.
                        if (stopPlayingRising) begin
                            // Move to idle state.
                            state <= STATE_IDLE;
                            // Disable the modem.
                            pwmModemEnable <= 1'b0;
                        end
                    end
                endcase
            end
        end
    end
    
endmodule
