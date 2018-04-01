`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/26 21:44:53
// Design Name: 
// Module Name: divisionByTen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: As the division is quite hard for the FPGA to do within 10ns, we
// would do our own division.
// With this would only need 8 clock cycles to get a closed value. We cannot used
// the origin 450MHz clock so the only thing is to use the 100MHz crystal clock.
// This is a fast division by 10 algorithm I implemented before, but I cannot 
// remember where I looked this before. If anyone who knows, let me add as a 
// reference.
// 
// Dependencies: N/A
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module divisionByTen(
    input wire [31:0] in_number,
    input wire        in_numberValid,
    input wire        in_reset,
    input wire        in_clock,
    input wire        in_enable,
    output wire       out_resultValid,
    output reg [31:0] out_result = 32'd0);
    
    // Define the state of the divider.
    localparam STATE_IDLE   = 3'd0;
    localparam STATE_INIT   = 3'd1;
    localparam STATE_SR_4   = 3'd2;
    localparam STATE_SR_8   = 3'd3;
    localparam STATE_SR_16  = 3'd4;
    localparam STATE_SR_3   = 3'd5;
    localparam STATE_GET_R  = 3'd6;
    localparam STATE_FINISH = 3'd7;
    // Initial the state to IDLE state.
    reg [2:0] state = STATE_IDLE;
    // Prepare two helper.
    reg [31:0] helper1, helper2;
    
    always @(posedge in_clock) begin
        // Check the reset state.
        if (in_reset) begin
            // Reset the state.
            state <= STATE_IDLE;
            // Reset the helper.
            helper1 <= 32'd0;
            helper2 <= 32'd0;
            // Reset the output
            out_result <= 32'd0;
        end else begin
            if (in_enable) begin
                case (state)
                    STATE_IDLE: begin
                        if (in_numberValid) begin
                            // Move to first step.
                            state <= STATE_INIT;
                            // Save the in number.
                            helper1 <= in_number;
                            helper2 <= in_number;
                            out_result <= 32'd0;
                        end
                    end
                    STATE_INIT: begin
                        // get 3/4 of the number.
                        helper1 <= (helper1 >> 1) + (helper1 >> 2);
                        state <= STATE_SR_4; 
                    end
                    STATE_SR_4: begin
                        // get 51/64 of the number.
                        helper1 <= helper1 + (helper1 >> 4);
                        state <= STATE_SR_8;
                    end
                    STATE_SR_8: begin
                        // get 13107/16384 of the number
                        helper1 <= helper1 + (helper1 >> 8);
                        state <= STATE_SR_16;
                    end
                    STATE_SR_16: begin
                        // get 858993459/1073741824 of the number.
                        helper1 <= helper1 + (helper1 >> 16);
                        state <= STATE_SR_3;
                    end
                    STATE_SR_3: begin
                        // get 858993459/8589934592 of the number.
                        helper1 <= helper1 >> 3;
                        state <= STATE_GET_R;  
                    end
                    STATE_GET_R: begin
                        // get 1/4294967296 of the number.
                        helper2 <= helper2 - (((helper1 << 2) + helper1) << 1);
                        state <= STATE_FINISH;
                    end
                    STATE_FINISH: begin
                        // Finally get the 858993459/8589934592+ of the number.
                        // Which is 0.09999+ of the number.
                        out_result <= helper1 + (helper2 > 9);
                        // Reset the state back to IDLE.
                        state <= STATE_IDLE;
                    end
                    default:
                        // Reset the state.
                        state <= STATE_IDLE;
                endcase
            end
        end
    end
    
    // When the state is IDLE, which means that the value has been fully calculated.
    assign out_resultValid = (state == STATE_IDLE);
    
endmodule
