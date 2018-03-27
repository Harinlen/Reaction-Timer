`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
// 
// Create Date: 2018/03/18 19:39:33
// Design Name: TEST State Logic Processor
// Module Name: reactTimerTestCore
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module is designed to execute the TEST.
// No SSD output is needed in this module, the result would be processed and then
// send the output.
// 
// Dependencies: 
//    - actionRetarder
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reactTimerTestCore #(
    parameter integer COUNTER_LIMITATION = 32'd9_9999_9999
)(
    input wire [31:0]   in_delay,
    input wire          in_start,
    input wire          in_enable,
    input wire          in_reset,
    input wire          in_testButton,
    input wire          in_clock,
    output reg          out_resultValid = 0,
    output reg          out_timeout = 0,
    output reg [27:0]   out_result = 0,
    output reg [15:0]   out_leds = 16'd0);
    
    // State for this module.
    localparam STATE_IDLE   = 2'd0;
    localparam STATE_WAIT   = 2'd1;
    localparam STATE_TEST   = 2'd2;
    localparam STATE_FINISH = 2'd3;
    
    reg [31:0] tickCounter = 32'd0;
    reg [1:0] state = STATE_IDLE;
    reg activatePulse = 0, testTimeout = 0;
    wire delayPulse, startRising, testButtonRising;
    
    // This signal retarder would delay the signal for a specific time.
    actionRetarder signalDelayer(
        .in_delayCounts(in_delay),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_pulseIn(activatePulse),
        .out_pulseOut(delayPulse));
    
    edgeDetector startDetector(
        .in_signal(in_start),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(startRising));
    
    edgeDetector testButton(
        .in_signal(in_testButton),
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(testButtonRising));
    
    // The divider for the tick counter.
    reg tickCounterValid = 1'b0;
    wire dividedResultValid;
    wire [31:0] dividedResult;
    divisionByTen tickCounterDivider(
        .in_number(tickCounter),
        .in_numberValid(tickCounterValid),
        .in_reset(in_reset),
        .in_clock(in_clock),
        .in_enable(in_enable),
        .out_resultValid(dividedResultValid),
        .out_result(dividedResult));
    
    wire dividedResultValidRising;
    edgeDetector dividedResultValidDetector(
         .in_signal(dividedResultValid),
         .in_clock(in_clock),
         .in_reset(in_reset),
         .in_enable(in_enable),
         .out_risingEdge(dividedResultValidRising));
    
    always @(posedge in_clock) begin
        // Check the signal.
        if (in_reset) begin
            // Reset the state and counter.
            state <= STATE_IDLE;
            tickCounter <= 32'd0;
            testTimeout <= 0;
            // Reset the activate pulse;
            activatePulse <= 0;
            // Reset the output data.
            out_leds <= 16'd0;
            out_resultValid <= 0;
            out_result <= 27'd0;
            // Lower the counter valid.
            tickCounterValid <= 1'b0;
        end else begin
            if (in_enable) begin
                case (state)
                    STATE_IDLE : begin
                        // Check the incoming signal.
                        if (startRising) begin
                            // Also switch to WAIT state.
                            state <= STATE_WAIT;
                            // Manually rising the activate pulse.
                            activatePulse <= 1;
                            // Reset the counter.
                            tickCounter <= 32'd0;
                            testTimeout <= 0;
                            out_leds <= 16'd0;
                            out_resultValid <= 0;
                            out_result <= 27'd0;
                            // Lower the counter valid.
                            tickCounterValid <= 1'b0;
                        end
                    end
                    STATE_WAIT : begin
                        // Fall the activate pulse.
                        activatePulse <= 0;
                        // Now, the only thing for this state is waiting for the delay pulse.
                        if (delayPulse) begin
                            // Switch to the TEST mode.
                            state <= STATE_TEST;
                            // Make the entire LED to light at this moment, also start to count clock cycle.
                            out_leds <= 16'hFFFF;       
                        end else begin
                            // Anti-Cheating
                            if (testButtonRising) begin
                                // Press the button before it flash.
                                // User cheat, finish this state.
                                state <= STATE_FINISH;
                                // When it goes here, which means timeout.
                                testTimeout <= 1;
                            end
                        end
                    end
                    STATE_TEST : begin
                        // Check whether the tester hit the button.
                        if (testButtonRising) begin
                            // Finally hit the button.
                            //Switch the state to finish for data output..
                            state <= STATE_FINISH;
                            // Raise the tick counter.
                            tickCounterValid <= 1'b1;
                        end else begin
                            // If the tick counter is still in the limitation.
                            if (tickCounter < COUNTER_LIMITATION) begin
                                // Count and wait until the test button hit.
                                tickCounter <= tickCounter + 1;
                            end else begin
                                //Switch the state to finish for data output..
                                state <= STATE_FINISH;
                                // When it goes here, which means timeout.
                                testTimeout <= 1;
                            end
                        end
                    end
                    STATE_FINISH : begin
                        // Check timeout state.
                        if (testTimeout) begin
                            // Set the timeout flag.
                            out_timeout <= 1;
                            out_result <= 27'd0;
                            // Disable the led data.
                            out_leds <= 16'd0;
                            // Make the result data valid.
                            out_resultValid <= 1;
                            // Set the state back to IDLE.
                            state <= STATE_IDLE;
                        end else begin
                            // Lower the valid signal.
                            tickCounterValid <= 1'b0;
                            // Check the result is out.
                            if (dividedResultValidRising) begin
                                // Calculate the timer.
                                out_result <= dividedResult[27:0];
                                // Disable the timeout flag.
                                out_timeout <= 0;
                                // Disable the led data.
                                out_leds <= 16'd0;
                                // Make the result data valid.
                                out_resultValid <= 1;
                                // Set the state back to IDLE.
                                state <= STATE_IDLE;
                            end
                        end                        
                    end
                endcase
            end
        end
    end
    
endmodule
