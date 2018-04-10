`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/18 00:19:28
// Design Name: Central Logic Processing Unit of Main Finite State Machine
// Module Name: reactTimerCpu
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module manages the progress of the entire process, which is
// designed to be the biggest state machine of the process.
// It is a Quad-core processor for different state, each state has its own input
// and output. The responsibility of this module is to passing the result of the
// correct processor to the output.
// 
// Dependencies: 
//    - edgeDetector
//    - reactTimerIdleCore
//    - reactTimerPrepareCore
//    - reactTimerResultCore
//    - reactTimerResultCore
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reactTimerCpu #(
    parameter integer IDLE_ANIMATION_THRESHOLD = 12_500_000,
    parameter integer PREPARE_COUNT_DOWN_THRESHOLD = 50_000_000,
    parameter integer PREPARE_TEST_DELAY_TIME = 0,
    parameter integer TEST_COUNTER_LIMITATION = 32'd9_9999_9999,
    parameter integer RESULT_BEST_FLASH_THRESHOLD = 12_500_000,
    parameter [31:0]   RESULT_WAITING_COUNTS = 10_0000_0000
)(
    input wire [31:0] in_microphoneNoise,
    input wire [31:0] in_globalTime,
    input wire [7:0]  in_keyboardData,
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    input wire        in_start,
    input wire        in_test,
    input wire        in_skipWait,
    input wire        in_clearBest,
    input wire        in_audioEnable,
    input wire        in_ledEnable,
    input wire        in_triColorLedEnable,
    output reg [15:0] out_leds = 16'd0,
    output reg [31:0] out_ssdOutput = 32'd0,
    output reg [7:0]  out_ssdDots = 8'b1111_1111,
    output reg [2:0]  out_triColorLeft = 3'd0,
    output reg [2:0]  out_triColorRight = 3'd0,
    output reg [7:0]  out_vramUpdateXPos = 8'd0, 
    output reg [7:0]  out_vramUpdateYPos = 8'd0, 
    output reg [7:0]  out_vramUpdateCharAscii = 8'd0, 
    output reg        out_vramUpdate = 1'b0,
    output wire [3:0] out_vgaRed,
    output wire [3:0] out_vgaGreen,
    output wire [3:0] out_vgaBlue,
    output reg        out_audioPwm = 1'b0,
    output reg        out_audioSd = 1'b0);
    
    // Defines the process states.
    localparam STATE_IDLE = 2'd0;
    /*
     * PREPARATION state, at this stage, the display would first start to count down from 5 to 1. 
     * After that display eight - and shows nothing.
     * Waiting for random time, all the LED would be lightened. 
     */
    localparam STATE_PREPARATION = 2'd1;
    /*
     * TEST state, at this stage, the user need to press the button. 
     */
    localparam STATE_TEST = 2'd2;
    /*
     * RESULT state, the board would display the result. After for several seconds, it will back to 
     * idle state, but save the best result.
     */
    localparam STATE_RESULT = 2'd3;
     
    //Initial the state as idle state.
    reg [1:0] state = STATE_IDLE;
    
    wire startButtonRising;
    
    // Detect the start button rising.
    edgeDetector startButtonEdge(
        .in_signal(in_start),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(startButtonRising));
    
    // State modules.
    localparam TEST_OUTPUT_LED = 0;
    localparam TEST_OUTPUT_AUDIO = 1;
    reg [1:0] testOutput = 2'd0;
    // Idle connections.
    reg idleAnimeReset = 0, idleClearBest = 0;
    wire [27:0] reactionTime;
    wire reactionTimeValid, reactionTimeout;
    wire [27:0] recordTime;
    wire bestLevelRPwm, bestLevelGPwm, bestLevelBPwm;
    wire [31:0] idleSsdOutput;
    wire [7:0] idleSsdDots;
    wire [15:0] idleLeds;
    // Prepare connections.
    wire prepareBusy, prepareBusyFalling;
    wire [31:0] prepareNumberOut;
    // Test connections.
    wire [31:0] testDelayTime;
    reg testStart = 0;
    wire testResultValidRising;
    wire [27:0] testResult;
    wire testResultValid;
    wire [15:0] testLed;
    wire testAudioPwm, testAudioSd;
    // Result connections.
    wire resultBusy, resultBusyFalling, resultLevelRPwm, resultLevelGPwm, resultLevelBPwm;
    wire [31:0] resultNumberOut;
    wire [7:0] resultSsdDots;
    
    // IDLE state processor
    reactTimerIdleCore #(
        .ANIMATION_THRESHOLD(IDLE_ANIMATION_THRESHOLD)
    ) stateIdleProcessor (
        .in_reactionTime(reactionTime),
        .in_reactionSsd(resultNumberOut),
        .in_reactionTimeout(reactionTimeout),
        .in_reactionTimeValid(reactionTimeValid),
        .in_animeReset(idleAnimeReset),
        .in_clearBest(idleClearBest),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_bestLevelRPwm(bestLevelRPwm), 
        .out_bestLevelGPwm(bestLevelGPwm), 
        .out_bestLevelBPwm(bestLevelBPwm),
        .out_bestTime(recordTime),
        .out_leds(idleLeds),
        .out_ssdOutput(idleSsdOutput),
        .out_ssdDots(idleSsdDots));
    
    // PREPARE state processor
    reactTimerPrepareCore #(
        .COUNT_DOWN_CLOCK_THRESHOLD(PREPARE_COUNT_DOWN_THRESHOLD),
        .TEST_DELAY_TIME(PREPARE_TEST_DELAY_TIME)
    ) statePrepareProcessor(
        .in_microphoneNoise(in_microphoneNoise),
        .in_globalTime(in_globalTime),
        .in_startRising(startButtonRising),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .out_busy(prepareBusy),
        .out_numberDisplay(prepareNumberOut),
        .out_delay(testDelayTime));

    edgeDetector prepareBusyDetector(
        .in_signal(prepareBusy),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_fallingEdge(prepareBusyFalling));

    // TEST state processor
    reactTimerTestCore #(
        .COUNTER_LIMITATION(TEST_COUNTER_LIMITATION)
    ) stateTestProcessor (
        .in_delay(testDelayTime),
        .in_start(testStart),
        .in_enable(in_enable),
        .in_reset(in_reset),
        .in_testButton(in_test),
        .in_clock(in_clock),
        .in_ledEnable(testOutput[TEST_OUTPUT_LED]),
        .in_audioEnable(testOutput[TEST_OUTPUT_AUDIO]),
        .out_resultValid(testResultValid),
        .out_timeout(reactionTimeout),
        .out_result(reactionTime),
        .out_leds(testLed),
        .out_audioSd(testAudioSd),
        .out_audioPwm(testAudioPwm));

    edgeDetector testResultValidDetector(
        .in_signal(testResultValid),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(testResultValidRising));
    
    // RESULT state processor    
    reactTimerResultCore #(
        .BEST_FLASH_THRESHOLD(RESULT_BEST_FLASH_THRESHOLD),
        .WAITING_COUNTS(RESULT_WAITING_COUNTS)
    ) stateResultProcessor (
        .in_testResult(reactionTime),
        .in_bestResult(recordTime),
        .in_testTimeout(reactionTimeout),
        .in_testResultValid(testResultValidRising),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_skipWait(in_skipWait),
        .out_busy(resultBusy),
        .out_reactionTimeValid(reactionTimeValid),
        .out_ssdNumberDisplay(resultNumberOut),
        .out_ssdDots(resultSsdDots),
        .out_resultLevelRPwm(resultLevelRPwm), 
        .out_resultLevelGPwm(resultLevelGPwm), 
        .out_resultLevelBPwm(resultLevelBPwm));
    
    // Detect the falling edge of the result busy signal.
    edgeDetector resultBusyDetector(
        .in_signal(resultBusy),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_fallingEdge(resultBusyFalling));
    
    task resetAudioOutput;
    begin
        // Reset the audio output.
        out_audioSd <= 1'b0;
        out_audioPwm <= 1'b0;
    end
    endtask
    
    task updateLeftLed;
    begin
        // Update the left tri-color LED data.
        out_triColorLeft <= {bestLevelRPwm & (in_triColorLedEnable), 
                             bestLevelGPwm & (in_triColorLedEnable), 
                             bestLevelBPwm & (in_triColorLedEnable)};
    end
    endtask
    
    // VGA hint update.
    localparam HINT_UPDATE_LED_ON     = 0;
    localparam HINT_UPDATE_LED_OFF    = 1;
    localparam HINT_UPDATE_AUDIO_ON   = 2;
    localparam HINT_UPDATE_AUDIO_OFF  = 3;
    localparam HINT_UPDATE_TRILED_ON  = 4;
    localparam HINT_UPDATE_TRILED_OFF = 5;
    reg [5:0] hintUpdateFlag = 6'b000000;
    reg hintUpdating = 1'b0;
    
    task updateVramOutput;
        input [7:0] xPos;
        input [7:0] yPos;
        input integer hintFlagOn;
        input integer hintFlagOff;
    begin
       // Update the vram X and Y pos.
       out_vramUpdateXPos <= xPos;
       out_vramUpdateYPos <= yPos;
       out_vramUpdateCharAscii <= hintUpdateFlag[hintFlagOn] ? 8'd251 : 8'd0;
       out_vramUpdate <= 1'b1;
       // Reset the flag.
       hintUpdateFlag[hintFlagOn] <= 1'b0;
       hintUpdateFlag[hintFlagOff] <= 1'b0; 
    end
    endtask
    
    // Keyboard processor.
    keyboardDecoder vgaColorControl(
        .in_keycode(in_keyboardData),
        .in_keycodeValid(1'b1),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .out_redColor(out_vgaRed),
        .out_greenColor(out_vgaGreen),
        .out_blueColor(out_vgaBlue)); 
    
    always @(posedge in_clock) begin
        // Check the reset button.
        if (in_reset) begin
            // Reset the state back to IDLE.
            state <= STATE_IDLE;
            // Reset the signal.
            out_leds <= 16'd0;
            out_ssdOutput <= `SSD_DISPLAY_BLANK;
            out_ssdDots <= 8'b1111_1111;
            // Reset the audio output.
            out_audioSd <= 1'b0;
            out_audioPwm <= 1'b0;
            // Reset the tri-color led output.
            out_triColorLeft <= 3'd0;
            out_triColorRight <= 3'd0;
            // Reset the state signals.
            idleClearBest <= 0;
            // Reset the vram output.
            out_vramUpdateXPos <= 8'd0; 
            out_vramUpdateYPos <= 8'd0; 
            out_vramUpdateCharAscii <= 8'd0;
            out_vramUpdate <= 1'b0;
            // Update the hint update flag.
            hintUpdateFlag <= 6'd0;
            hintUpdating <= 1'b0;
        end else begin
            if (in_enable) begin
                // Check the current state.
                case (state)
                    /*
                     * IDLE state, at this stage, the display would flash -, and the LED would play an animation.
                     * Until the user hit the test button, it would always be in this state.
                     */
                    STATE_IDLE: begin
                        // If just set from reset, update all the thing.
                        if (hintUpdating) begin
                            // Update the vram according to the input.
                            if (hintUpdateFlag[HINT_UPDATE_LED_ON] | hintUpdateFlag[HINT_UPDATE_LED_OFF]) begin
                                // Ignore the update flag.
                                updateVramOutput(8'd16, 8'd14, HINT_UPDATE_LED_ON, HINT_UPDATE_LED_OFF);
                            end else if (hintUpdateFlag[HINT_UPDATE_AUDIO_ON] | hintUpdateFlag[HINT_UPDATE_AUDIO_OFF]) begin
                                // Update the Audio output.
                                updateVramOutput(8'd16, 8'd15, HINT_UPDATE_AUDIO_ON, HINT_UPDATE_AUDIO_OFF);
                            end else if (hintUpdateFlag[HINT_UPDATE_TRILED_ON] | hintUpdateFlag[HINT_UPDATE_TRILED_OFF]) begin
                                // Update the tri-color LED output.
                                updateVramOutput(8'd16, 8'd19, HINT_UPDATE_TRILED_ON, HINT_UPDATE_TRILED_OFF);
                            end else begin
                                // Clear the vram update.
                                out_vramUpdate <= 1'b0;
                                // No more need to update.
                                hintUpdating <= 1'b0;
                            end
                        end else begin
                            // Update the hint update flag.
                            // Check the rising and falling edge of the signal.
                            hintUpdateFlag = {~in_triColorLedEnable, in_triColorLedEnable, 
                                              ~in_audioEnable, in_audioEnable, 
                                              ~in_ledEnable, in_ledEnable};
                            // Start update the hint.
                            hintUpdating <= 1'b1;
                        end
                        // Check the rising edge of the start button.
                        if (startButtonRising) begin
                            // Move the state to preparation.
                            state <= STATE_PREPARATION;
                            // Update the register for output.
                            testOutput <= {in_audioEnable, ((~in_audioEnable) | in_ledEnable)};
                            // Disable the idle clear best.
                            idleClearBest <= 1'b0;
                            // Clear the left and right tri-color output.
                            out_triColorLeft <= 3'd0;
                            out_triColorRight <= 3'd0;
                            // No more need to update.
                            hintUpdating <= 1'b0;
                        end else begin
                            // Ports the result of idle module to the result.
                            // Output the LED signal.
                            out_leds <= idleLeds;
                            // Output the SSD data.
                            out_ssdOutput <= idleSsdOutput;
                            out_ssdDots <= idleSsdDots;
                            // Update the idle clear best signal.
                            if (in_clearBest & (~idleClearBest)) begin
                                idleClearBest <= 1'b1;
                            end else begin
                                idleClearBest <= 1'b0;
                            end
                            // Update the left tri-color LED.
                            updateLeftLed();
                            out_triColorRight <= 3'd0;
                        end
                        // Clear the animation reset to 0.
                        idleAnimeReset <= 0;
                        // Reset the audio output.
                        resetAudioOutput();
                    end
                    STATE_PREPARATION : begin
                        // Waiting until the prepare core not to be busy.
                        if (prepareBusyFalling) begin
                            // Switch the state to TEST state.
                            state <= STATE_TEST;
                            // Reset the LED again, though worth nothing.
                            out_leds <= 16'd0;
                            // Reset the SSD output.
                            out_ssdOutput <= `SSD_DISPLAY_BLANK;
                            out_ssdDots <= 8'b1111_1111;
                            // Start testing.
                            testStart <= 1'b1;
                        end else begin
                            // Disable all the LED output.
                            out_leds <= 16'd0;
                            // Output the SSD data.
                            out_ssdOutput <= prepareNumberOut;
                            out_ssdDots <= 8'b1111_1111;
                        end
                        // Reset the audio output.
                        resetAudioOutput();
                    end
                    STATE_TEST: begin
                        // Fall the testing flag.
                        testStart <= 1'b0;
                        // Check test result rising.
                        if (testResultValidRising) begin
                            // Get the test result, move to RESULT state.
                            state <= STATE_RESULT;
                            // Disable all the LEDs.
                            out_leds <= 16'd0;
                        end else begin
                            // Port the data to the LEDs.
                            out_leds <= testLed;
                            // Output the audio data from the processor.
                            out_audioSd <= testAudioSd;
                            out_audioPwm <= testAudioPwm;
                        end
                    end
                    STATE_RESULT: begin
                        // When it comes to RESULT state, check the timeout state.
                        if (resultBusyFalling) begin
                            // When the result module is no more busy, 
                            // switch state back to IDLE.
                            state <= STATE_IDLE;
                            // Set the animation reset to 1.
                            idleAnimeReset <= 1;
                            // Reset the tri-color led output.
                            out_triColorRight <= 3'd0;
                            // Reset the hint update flag.
                            hintUpdateFlag <= 6'b000000;
                            hintUpdating <= 1'b1;
                        end else begin
                            // Output the current tri-color LED result with the best result.
                            updateLeftLed();
                            out_triColorRight <= {resultLevelRPwm & (in_triColorLedEnable), 
                                                  resultLevelGPwm & (in_triColorLedEnable), 
                                                  resultLevelBPwm & (in_triColorLedEnable)};
                            // Output the result SSD data to ports.
                            out_ssdOutput <= resultNumberOut;
                            out_ssdDots <= resultSsdDots;
                        end
                        // Reset the audio output.
                        resetAudioOutput();
                    end
                endcase
            end
        end
    end
    
endmodule
