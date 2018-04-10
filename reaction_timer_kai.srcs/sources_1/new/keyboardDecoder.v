`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2018 12:38:21
// Design Name: 
// Module Name: keyboardDecoder
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


module keyboardDecoder(
    input wire       in_reset,
    input wire       in_enable,
    input wire       in_clock,
    input wire [7:0] in_keycode,
    input wire       in_keycodeValid,
    output reg [3:0] out_redColor = 4'b1111,
    output reg [3:0] out_greenColor = 4'b1111,
    output reg [3:0] out_blueColor = 4'b1111);
    
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the RGB out.
            out_redColor = 4'b1111;
            out_greenColor = 4'b1111;
            out_blueColor = 4'b1111;
        end else begin
            if (in_enable) begin
                // Operate only when keycode is valid.
                if (in_keycodeValid) begin
                    // Check the key input.
                    case (in_keycode)
                        8'h15: out_redColor   <= 4'b0001; //  Q
                        8'h1D: out_redColor   <= 4'b0011; //  W
                        8'h24: out_redColor   <= 4'b0111; //  E
                        8'h2D: out_redColor   <= 4'b1111; //  R
                        8'h1C: out_greenColor <= 4'b0001; // A
                        8'h1B: out_greenColor <= 4'b0011; // S
                        8'h23: out_greenColor <= 4'b0111; // D
                        8'h2B: out_greenColor <= 4'b1111; // F
                        8'h1A: out_blueColor  <= 4'b0001; //Z
                        8'h22: out_blueColor  <= 4'b0011; //X
                        8'h21: out_blueColor  <= 4'b0111; //C
                        8'h2A: out_blueColor  <= 4'b1111; //V
                        8'h29: begin // Space 
                            out_redColor   <= 4'b1111;
                            out_greenColor <= 4'b1111;
                            out_blueColor  <= 4'b1111;
                        end
                        8'h5A: begin // Enter
                            out_redColor   <= 4'b0000;
                            out_greenColor <= 4'b0000;
                            out_blueColor  <= 4'b0000;
                        end
                        default: ; //Do nothing
                    endcase
                end
            end
        end
    end
    
endmodule
