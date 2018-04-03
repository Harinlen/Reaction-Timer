`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/18 21:46:13
// Design Name: RESULT State Logic Processor
// Module Name: reactTimerResultCore
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to display the test result.
// 
// Dependencies: 
//    - digitSeperator
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module reactTimerResultCore #(
    parameter integer   BEST_FLASH_THRESHOLD = 12_500_000,
    parameter [31:0]    WAITING_COUNTS = 10_0000_0000,
    parameter integer   RESULT_LEVEL_PWM_DELAY = 0
)(
    input wire [27:0]   in_testResult,
    input wire [27:0]   in_bestResult,
    input wire          in_testTimeout,
    input wire          in_testResultValid,
    input wire          in_clock,
    input wire          in_reset,
    input wire          in_enable,
    output wire         out_busy,
    output reg          out_reactionTimeValid = 1'b0,
    output reg [31:0]   out_ssdNumberDisplay = `SSD_DISPLAY_BLANK,
    output reg [7:0]    out_ssdDots = 8'b1111_1111,
    output wire         out_resultLevelRPwm, 
    output wire         out_resultLevelGPwm, 
    output wire         out_resultLevelBPwm);
    
    /*
     * IDLE: Wait for test result validation.
     */
    localparam STATE_IDLE = 2'd0;
    /*
     * CONVERT: Wait for binary to BCD converter finish converting.
     */
    localparam STATE_CONVERT = 2'd1;
    /*
     * WAIT: Busy for showing the result.
     */
    localparam STATE_WAIT = 2'd2;
    reg [1:0] state = STATE_IDLE;
    
    wire [31:0] testResultDigit;
    reg isBestResult = 1'b0, isResultReady = 1'b0;
    reg pwmModemEnable = 1'b0;
    wire testResultValidRising, flashClock, testResultDigitReady, testResultDigitReadyRising;
    
    // RGB output for level.
    reg [7:0] resultLevelR = 8'd0, resultLevelG = 8'd0, resultLevelB = 8'd0; 
    wire [7:0] resultLevel;
    assign resultLevel = in_testResult[27:20];
    
    // Result level PWM Modem
    // Red
    PwmModem #(
        .COUNTER_DELAY(RESULT_LEVEL_PWM_DELAY) 
    ) resultLevelRPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable & pwmModemEnable),
        .in_clock(in_clock),
        .in_numberIn(resultLevelR),
        .out_pwmWave(out_resultLevelRPwm));
    // Green
    PwmModem #(
        .COUNTER_DELAY(RESULT_LEVEL_PWM_DELAY) 
    ) resultLevelGPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable & pwmModemEnable),
        .in_clock(in_clock),
        .in_numberIn(resultLevelG),
        .out_pwmWave(out_resultLevelGPwm));
    // Blue
    PwmModem #(
        .COUNTER_DELAY(RESULT_LEVEL_PWM_DELAY) 
    ) resultLevelBPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable & pwmModemEnable),
        .in_clock(in_clock),
        .in_numberIn(resultLevelB),
        .out_pwmWave(out_resultLevelBPwm));
    
    // Seperate the number to the test result.
    decimalToBcd testResultSeperator(
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_number(in_testResult),
        .in_numberValid(isResultReady),
        .out_bcdValid(testResultDigitReady),
        .out_bcd(testResultDigit));
        
    edgeDetector testResultDigitReadyDetector(
        .in_signal(testResultDigitReady),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(testResultDigitReadyRising));
    
    // Detect the result valid rising edge.
    edgeDetector testResultValidDetector(
        .in_signal(in_testResultValid),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(testResultValidRising));
    
    // Best result flash clock divider.
    clockDivider #(
       .THRESHOLD(BEST_FLASH_THRESHOLD)
    ) clock1Hz (
       .in_clock(in_clock),
       .in_reset(in_reset | (state != 2'd2)),
       .in_enable(in_enable),
       .out_dividedClock(flashClock));
    
    // Timer for waiting 10s with no action.
    reg startWaitingPulse = 1'b0;
    wire endWaitingPulse;
    actionRetarder idleCounter(
        .in_delayCounts(WAITING_COUNTS),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_pulseIn(startWaitingPulse),
        .out_pulseOut(endWaitingPulse));
        
    task ssdDisplayBlank;
    begin
        // Clear the number output.
        out_ssdNumberDisplay <= `SSD_DISPLAY_BLANK;
        // Clear the dot output.
        out_ssdDots <= 8'b1111_1111;
    end
    endtask
    
    task ssdDisplayResult;
    begin
        // Pass the parse result to display.
        out_ssdNumberDisplay <= testResultDigit;
        // Show the left most dot.
        out_ssdDots <= 8'b0111_1111;
    end
    endtask
    
    always @(posedge in_clock) begin
        // Check the reset signal.
        if (in_reset) begin
            // Reset the state.
            state <= STATE_IDLE;
            // Reset the best result.
            isBestResult <= 1'b0;
            // Reset the ssd outputs.
            ssdDisplayBlank();
            out_reactionTimeValid <= 1'b0;
            // Reset the start waiting pulse.
            startWaitingPulse <= 0;
            // Reset the result level.
            resultLevelR <= 8'd0;
            resultLevelG <= 8'd0;
            resultLevelB <= 8'd0;
            // Reset the enable data.
            pwmModemEnable <= 1'b0;
        end else begin
            if (in_enable) begin
                // Check the current state.
                case (state)
                    STATE_IDLE: begin
                        // Wait for the test result validation rising.
                        if (testResultValidRising) begin
                            // Check the timeout state.
                            if (in_testTimeout) begin
                                // For timeout, definitely not best result.
                                isBestResult <= 0;
                                // Change state to wait.
                                state <= STATE_WAIT;
                                // Display the result right at the moment.
                                ssdDisplayResult();
                                // Start waiting.
                                startWaitingPulse <= 1;
                                // Update the reaction time validation.
                                out_reactionTimeValid <= 1'b1;
                            end else begin
                                // Update the best result state.
                                isBestResult <= (in_bestResult == 27'd0) | (in_testResult <= in_bestResult);
                                // Change state for converting ssd result.
                                state <= STATE_CONVERT;
                                // Update the RGB result according to the test result.
                                resultLevelR <= (resultLevel < 52) ? 255 : ((resultLevel < 102) ? ((102-resultLevel)*5) : ((resultLevel < 204) ? 0 : ((resultLevel-204)*5)));
                                resultLevelG <= (resultLevel < 51) ? (resultLevel * 5) : ((resultLevel < 153) ? 255 : ((resultLevel < 204) ? ((204-resultLevel)*5) : 0));
                                resultLevelB <= (resultLevel < 102) ? 0 : ((resultLevel > 153) ? 255 : ((resultLevel - 102) * 5));
                                // Enable PWM.
                                pwmModemEnable <= 1'b1;
                                // Start converting.
                                isResultReady <= 1'b1;
                            end
                        end else begin
                            // Reset the waiting pulse.
                            startWaitingPulse <= 0;
                            // Reset the reaction time validation.
                            out_reactionTimeValid <= 1'b0;
                        end
                    end
                    STATE_CONVERT: begin
                        // Waiting for the respond from the bcd converter.
                        if (testResultDigitReadyRising) begin
                            // Change state to wait.
                            state <= STATE_WAIT;
                            // Display the result right at the moment.
                            ssdDisplayResult();
                            // Start waiting.
                            startWaitingPulse <= 1;
                            // Reset the result ready flag.
                            isResultReady <= 1'b0;
                            // Update the reaction time validation.
                            out_reactionTimeValid <= 1'b1;
                        end
                    end
                    STATE_WAIT: begin
                        // Falling the start waiting pulse.
                        startWaitingPulse <= 0;
                        // Check the timeout state.
                        if (endWaitingPulse) begin
                            // Timeout, no more busy.
                            // Reset the module state.
                            state <= STATE_IDLE;
                            // Reset the ssd outputs.
                            ssdDisplayBlank();
                            // Reset the PWM enable state.
                            pwmModemEnable <= 1'b0;
                        end else begin
                            // According to different state.
                            if (in_testTimeout) begin
                                // Output for all -.
                                out_ssdNumberDisplay <= `SSD_DISPLAY_FAIL;
                                // Clear the dot output.
                                out_ssdDots <= 8'b1111_1111;
                            end else begin
                                if (isBestResult & flashClock) begin
                                    // Flash hidden state.
                                    ssdDisplayBlank();
                                end else begin
                                    // Normal result, or not at flashing state, just simply display the result.
                                    ssdDisplayResult();
                                end
                            end
                        end
                    end
                endcase
            end
        end
    end
    
    // When state is not STATE_IDLE, which means that this module is busy.
    assign out_busy = (state != STATE_IDLE);
    
endmodule
