`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/26 15:50:44
// Design Name: Decimal to BCD converter
// Module Name: decimalToBcd
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module uses Shift-Add algorithm to convert a 28-bit binary number
// into a 32-bit Binary Coded Decimal (BCD) with 28 iterations, which is maximum 56 
// clock cycle.
// 
// Dependencies: 
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module decimalToBcd(
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    input wire [27:0] in_number,
    input wire        in_numberValid,
    output wire       out_bcdValid,
    output reg [31:0] out_bcd = `SSD_DISPLAY_BLANK);
    
    localparam STATE_IDLE = 2'd0;
    localparam STATE_SHIFT = 2'd1;
    localparam STATE_ADD = 2'd2;
    // State for the encoder.
    reg [1:0] state = STATE_IDLE;
    
    reg [27:0] currentNumber = 28'd0;
    reg [31:0] bcdCache = 32'd0;
    reg [4:0] counter = 5'd0;
    
    // Detect the number is valid or not.
    wire numberValidRising;
    edgeDetector numberValidDetector(
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_signal(in_numberValid),
        .out_risingEdge(numberValidRising));
    
    always @(posedge in_clock) begin
        // Check for reset signal.
        if (in_reset) begin
            // Reset the bcd output.
            out_bcd <= `SSD_DISPLAY_BLANK;
        end else begin
            if (in_enable) begin
                // Check for the current state.
                case (state)
                    STATE_IDLE: begin
                        // Detect the rising edge of the number validation.
                        if (numberValidRising) begin
                            // Assign the state to shift
                            state <= STATE_SHIFT;
                            // Get the number;
                            currentNumber <= in_number;
                            // Reset the bcd cache.
                            bcdCache <= 32'd0;
                            // Reset the counter.
                            counter <= 5'd27;
                            out_bcd <= `SSD_DISPLAY_BLANK;
                        end
                    end
                    STATE_SHIFT: begin
                        if (counter==0) begin
                            // Complete back to IDLE.
                            state <= STATE_IDLE;
                            // Output the BCD.
                            out_bcd <= {bcdCache[30:0], currentNumber[27]};
                        end else begin
                            // Left the data left.
                            bcdCache <= {bcdCache[30:0], currentNumber[27]};
                            // Left shift the current number.
                            currentNumber <= {currentNumber[26:0], 1'b0};
                            // Move the state to add.
                            state <= STATE_ADD;
                        end
                        
                    end
                    STATE_ADD: begin
                        // Check whether each unit is greater than 4.
                        if (bcdCache[3:0] > 4'd4) begin
                            bcdCache[3:0] <= bcdCache[3:0] + 4'd3;
                        end
                        if (bcdCache[7:4] > 4'd4) begin
                            bcdCache[7:4] <= bcdCache[7:4] + 4'd3;
                        end
                        if (bcdCache[11:8] > 4'd4) begin
                            bcdCache[11:8] <= bcdCache[11:8] + 4'd3;
                        end
                        if (bcdCache[15:12] > 4'd4) begin
                            bcdCache[15:12] <= bcdCache[15:12] + 4'd3;
                        end
                        if (bcdCache[19:16] > 4'd4) begin
                            bcdCache[19:16] <= bcdCache[19:16] + 4'd3;
                        end
                        if (bcdCache[23:20] > 4'd4) begin
                            bcdCache[23:20] <= bcdCache[23:20] + 4'd3;
                        end
                        if (bcdCache[27:24] > 4'd4) begin
                            bcdCache[27:24] <= bcdCache[27:24] + 4'd3;
                        end
                        if (bcdCache[31:28] > 4'd4) begin
                            bcdCache[31:28] <= bcdCache[31:28] + 4'd3;
                        end
                        // Check the counter.
                        if (counter) begin
                            // Decrease the counter.
                            counter <= counter - 1;
                            // Move the state to shift.
                            state <= STATE_SHIFT;
                        end
                    end
                endcase
            end
        end
    end
    
    assign out_bcdValid = (state == STATE_IDLE);
    
endmodule
