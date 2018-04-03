`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 22.03.2018 14:49:46
// Design Name: 8-bit Integer PWM Modulator
// Module Name: PwmModem
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to output a number as a PWM signal. The input
// signal must be a 8-bit number. The frequency would be tweak according to the threshold
// parameter.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PwmModem #(
    parameter [7:0]  COUNTER_DELAY = 221 
)(
    input wire       in_reset,
    input wire       in_enable,
    input wire       in_clock,
    input wire [7:0] in_numberIn,
    output reg       out_switchSample = 1'b0,
    output reg       out_pwmWave = 1'b0);
    
    // Prepare the accumulator for the PWM signal.
    reg [7:0] accumulator = 8'd0;
    reg [7:0] lastAudioSample = 8'd0;
	reg [7:0] slowerCounter = 8'd0;
	
	// Reset the modem states.
	task resetPwmModemStates;
	begin
	   // Reset the counter.
       accumulator <= 8'd0;
       lastAudioSample <= 8'd0;
       slowerCounter <= 8'b0;
       // Reset the output.
       out_pwmWave <= 1'b0;
       out_switchSample <= 1'b0;
	end
	endtask
      
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the modem states.
            resetPwmModemStates();
        end else begin
            if (in_enable) begin
				// First check the slower counter.
				if (slowerCounter == COUNTER_DELAY) begin
					// Check the accumulator number.
					if (accumulator == 8'd0) begin
						// Update for last audio sample.
						lastAudioSample <= in_numberIn;
						// Update the pwm.
						out_pwmWave <= (in_numberIn != 16'd0);
						// Increase the accumulator.
						accumulator <= accumulator + 8'd1;
						// Update the out switch.
						out_switchSample <= 1'b0;
					end else begin
						// Update the accumulator.
						accumulator <= accumulator + 8'd1;
						// Update the pwm output.
						out_pwmWave <= (accumulator < lastAudioSample);
						// Update the switch simple.
                        out_switchSample <= (accumulator < 8'd128);
					end
					// Reset the slower counter.
					slowerCounter <= 8'd0;
				end else begin
					// Increase the slower counter.
					slowerCounter <= slowerCounter + 8'd1;
				end
            end else begin
                // Same as the modem reset.
                resetPwmModemStates();
            end
        end
    end
    
endmodule
