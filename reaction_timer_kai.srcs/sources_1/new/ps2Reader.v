`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 10.04.2018 12:13:39
// Design Name: PS/2 Data Receiver 
// Module Name: ps2Reader
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This module could read the data of PS/2 by byte (8-bit). The working
// clock of this module is 50MHz.
// 
// Dependencies: 
//    - delayDebouncer
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ps2Reader(
    input wire       in_reset,
    input wire       in_enable,
    input wire       in_clock,
    input wire       in_ps2Clock,
    input wire       in_ps2Data,
    output reg [7:0] out_data = 8'd0);
    
    wire ps2DebouncedClock, ps2DebouncedData;
    reg [7:0] currentData = 8'dZ;
    reg [7:0] previousData = 8'dZ;
    reg [3:0] counter = 4'b0000;
    reg [31:0] keycode = 32'h00000000;
    reg flag = 1'b0;
    
    delayDebouncer clkDeb(
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .in_signal(in_ps2Clock),
        .out_debouncedSignal(ps2DebouncedClock));
        
    delayDebouncer dataDeb(
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_clock),
        .in_signal(in_ps2Data),
        .out_debouncedSignal(ps2DebouncedData));

    // Triggered when the debounced PS/2 clock falling.
    always @(negedge ps2DebouncedClock) begin
        // Check the counter.
        case(counter)
            4'd0:  ; //Start bit
            4'd1:  currentData[0] <= ps2DebouncedData;
            4'd2:  currentData[1] <= ps2DebouncedData;
            4'd3:  currentData[2] <= ps2DebouncedData;
            4'd4:  currentData[3] <= ps2DebouncedData;
            4'd5:  currentData[4] <= ps2DebouncedData;
            4'd6:  currentData[5] <= ps2DebouncedData;
            4'd7:  currentData[6] <= ps2DebouncedData;
            4'd8:  currentData[7] <= ps2DebouncedData;
            4'd9:  flag<=1'b1; // Set the flag.
            4'd10: flag<=1'b0;
        endcase
        // Raw back the counter.
        if (counter <= 9) begin
            counter <= counter + 1;
        end else if(counter==10) begin
            counter <= 0;
        end 
    end
    
    // When the flag is triggered, output the data.
    always @(posedge flag) begin
        if ((~in_reset) & in_enable) begin
            // Check the previous data is the same as the current one.
            // We would like to ignore the same key code.
            if (out_data != currentData)begin
                // Output the data.
                out_data <= currentData;
            end
        end
    end
    
endmodule
