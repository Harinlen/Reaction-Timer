`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/17 22:55:47
// Design Name: Pipeline Sampling Debouncer
// Module Name: debouncer
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: The signal debouncer described in the lab. It would add delay to 
// the signal.
// The pipeline level is given as a parameter. The default pipeline depth is 4.
// Support maximum 32-level pipeline.
// 
// Dependencies: 
//    - edgeDetector
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer #(
    parameter integer PIPELINE_LEVEL = 4
)(
    input wire          in_clock,
    input wire          in_enable,
    input wire          in_reset,
    input wire          in_buttonIn,
    output wire         out_buttonOut);
    
    reg [PIPELINE_LEVEL:0] pipeline = ~0;
    wire enableRising;
    
    edgeDetector enableDetector(
        .in_clock(in_clock),
        .in_reset(in_reset),
        .in_enable(1'b1),
        .in_signal(in_enable),
        .out_risingEdge(enableRising));
       
    // Sample and left shift the pipeline. 
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the pipeline.
            pipeline <= ~0;
        end else begin
            if (enableRising) begin
                // Set the last bit to the pipeline.
                pipeline <= {pipeline[PIPELINE_LEVEL-1:0], ~in_buttonIn};
            end
        end
    end
    
    // Assign the output as the pipeline is entirely 0.
    assign out_buttonOut = (pipeline == 0);
    
endmodule
