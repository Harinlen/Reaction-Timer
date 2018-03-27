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
    parameter [7:0]  PLAYING_CLOCK_THRESHOLD = 221 
)(
    input wire       in_reset,
    input wire       in_enable,
    input wire       in_clock,
    input wire [7:0] in_audioSample,
    output reg       out_audioPwmWave = 1'b0);
    
    // Prepare the accumulator for the PWM signal.
    reg [7:0] accumulator = 8'd0;
    reg [7:0] lastAudioSample = 8'd0;
	reg [7:0] slowerCounter = 8'd0;
      
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the accumulator.
            accumulator <= 16'd0;
            // Reset the PWM output data.
            out_audioPwmWave <= 1'b0;
			slowerCounter <= 8'b0;
        end else begin
            if (in_enable) begin
				// First check the slower counter.
				if (slowerCounter == PLAYING_CLOCK_THRESHOLD) begin
					// Check the accumulator number.
					if (accumulator == 8'd0) begin
						// Update for last audio sample.
						lastAudioSample <= in_audioSample;
						// Update the pwm.
						out_audioPwmWave <= (in_audioSample != 16'd0);
						// Increase the accumulator.
						accumulator <= accumulator + 8'd1;
					end else begin
						// Update the accumulator.
						accumulator <= accumulator + 8'd1;
						// Update the pwm output.
						out_audioPwmWave <= (accumulator < lastAudioSample);
					end
					// Reset the slower counter.
					slowerCounter <= 8'd0;
				end else begin
					// Increase the slower counter.
					slowerCounter <= slowerCounter + 8'd1;
				end
            end
        end
    end
    
endmodule
