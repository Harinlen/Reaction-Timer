`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2018 10:57:34
// Design Name: 
// Module Name: resetDebouncer
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


module resetDebouncer #(
    parameter integer LATCHED_COUNT = 4,
    parameter integer DEBOUNCED_CLOCK = 50_000,
    parameter integer FALLING_COUNT = 5
)(
    input wire        in_resetButton,
    input wire        in_clock,
    output wire       out_reset);
    
    localparam STATE_BUTTON_OFF = 0;
    localparam STATE_BUTTON_ON = 1;
    reg state = STATE_BUTTON_OFF;
    reg [31:0] latchedCounter = 32'd0;
    reg [31:0] fallingCounter = 32'd0;
    
    // 1kHz clock.
    wire clockDebouncerEnable;
    clockDivider #(
        .THRESHOLD(DEBOUNCED_CLOCK)
    ) clockEnable (
        .in_clock(in_clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_dividedClock(clockDebouncerEnable));
    
    // 1kHz clock edge detector.
    wire clockEnableRising;
    edgeDetector clockEnableDetector(
        .in_signal(clockDebouncerEnable),
        .in_clock(in_clock),
        .in_reset(1'b0),
        .in_enable(1'b1),
        .out_fallingEdge(clockEnableRising));
    
    always @(posedge in_clock) begin
        if (state) begin
            // STATE_BUTTON_ON
            if (latchedCounter < LATCHED_COUNT) begin
                // Increase the counter.
                latchedCounter <= latchedCounter + 1;
            end else begin
                // Check whether the button is falling for several times.
                if (clockEnableRising) begin
                    // CHeck the reset button value.
                    if (~in_resetButton) begin
                        if (fallingCounter < FALLING_COUNT) begin
                            // Increase counting for the falling.
                            fallingCounter <= fallingCounter + 1;
                        end else begin
                            // The button is really falling.
                            state <= STATE_BUTTON_OFF;
                        end
                    end else begin
                        // It is still on or failling bouncing, reset the falling counter.
                        fallingCounter <= 32'd0;
                    end
                end
            end
        end else begin
            // STATE_BUTTON_OFF.
            // Check the button value.
            if (in_resetButton) begin
                // Latch it.
                state <= STATE_BUTTON_ON;
                // Reset the latch.
                latchedCounter <= 32'd0;
                fallingCounter <= 32'd0;
            end
        end
    end
    
    // When the state is set as STATE_BUTTON_ON, then treat the reset button is pressed.
    assign out_reset = (state == STATE_BUTTON_ON);
    
endmodule
