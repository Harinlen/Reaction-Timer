`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2018 12:13:39
// Design Name: 
// Module Name: ps2Reader
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


module ps2Reader(
    input wire       in_reset,
    input wire       in_enable,
    input wire       in_clock,
    input wire       in_ps2Clock,
    input wire       in_ps2Data,
    output reg [7:0] out_data = 8'd0,
    output reg       out_dataValid = 1'b0);
    
    wire ps2DebouncedClock, ps2DebouncedData;
    reg [7:0] currentData = 8'dZ;
    reg [7:0] previousData = 8'dZ;
    reg [3:0] counter = 4'b0000;
    reg [31:0] keycode = 32'h00000000;
    reg flag = 1'b0, dataReady = 1'b0;
    
    reg CLK50MHZ = 1'b0;
    always @(posedge in_clock)begin
        CLK50MHZ <= ~CLK50MHZ;
    end
    
    delayDebouncer clkDeb(
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(CLK50MHZ),
        .in_signal(in_ps2Clock),
        .out_debouncedSignal(ps2DebouncedClock));
        
    delayDebouncer dataDeb(
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(CLK50MHZ),
        .in_signal(in_ps2Data),
        .out_debouncedSignal(ps2DebouncedData));
        
    always @(negedge ps2DebouncedClock) begin
        // According to the counter, set the data.
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
            4'd9:  flag<=1'b1;
            4'd10: flag<=1'b0;
        endcase
        // Increase the counter
        if (counter <= 9) begin
            counter <= counter + 1;
        end else if(counter==10) begin
            counter <= 0;
        end 
    end

    always @(posedge flag) begin
        if ((~in_reset) & in_enable) begin
            if (out_data != currentData)begin
                // Output the data.
                out_data <= currentData;
                // Set the data ready flag.
                dataReady <= 1'b1;
            end
        end
    end
    
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Clear the out data.
            out_data <= 8'd0;
            out_dataValid <= 1'b0;
        end else begin
            if (in_enable) begin
                // Check the data ready flag.
                if (dataReady) begin
                    // Give a data valid pulse.
                    dataReady <= 1'b0;
                    out_dataValid <= 1'b1;
                end else begin
                    // Reset the data valid.
                    out_dataValid <= 1'b0;
                end
            end
        end
    end
    
endmodule
