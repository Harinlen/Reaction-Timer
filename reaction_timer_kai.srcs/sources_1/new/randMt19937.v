`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/28 22:18:15
// Design Name: 
// Module Name: randMt19937
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

`include "globalConstants.v"

module randMt19937 #(
    parameter integer N = 624,          // length of state vector
    parameter integer M = 397,          // a period parameter
    parameter integer K = 32'h9908B0DF, // a magic constant
    parameter integer A = 69069         // the parameter of the equation
)(
    input wire [31:0] in_globalTime,
    input wire [31:0] in_seed,
    input wire        in_seedReady,
    input wire        in_next,
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    output reg [31:0] out_data = 32'd0,
    output reg        out_busy = `OUTPUT_INVALID);
    
    localparam [1:0] STATE_IDLE = 2'd0;
    localparam [1:0] STATE_CHECKING = 2'd1;
    localparam [1:0] STATE_BUSY = 2'd2;
    reg [1:0] state = STATE_IDLE;
    
    localparam STAGE_NONE = 0;
    localparam STAGE_SEED = 1;
    localparam STAGE_RELOAD = 2;
    localparam STAGE_RANDOM = 3;
    reg [31:0] stageIndex = STAGE_NONE;
    reg fromReloadStage = 1'b0, fromRandomStage = 1'b0;
    
    localparam FLAG_NEXT = 1;
    localparam FLAG_INITSEED = 0;
    reg [1:0] flags = 2'd0;
    
    reg [31:0] vecState [N:0];
    reg [31:0] nextIndex = 0;
    reg signed [31:0] left = -1;
    
    // Seed using values.
    reg [31:0] x, j, s;
    // Reload using values.
    localparam [2:0] RELOAD_INIT   = 3'd0;
    localparam [2:0] RELOAD_LOOP1  = 3'd1;
    localparam [2:0] RELOAD_LOOP2  = 3'd2;
    localparam [2:0] RELOAD_FINAL1 = 3'd3;
    localparam [2:0] RELOAD_FINAL2 = 3'd4;
    localparam [2:0] RELOAD_FINAL3 = 3'd5;
    localparam [2:0] RELOAD_FINAL4 = 3'd6;
    reg [2:0] reloadState = RELOAD_INIT;
    reg [31:0] s0, s1, p0, p2, pM, reloadResult;
    // Random using values.
    localparam [2:0] RANDOM_INIT   = 3'd0;
    localparam [2:0] RANDOM_FINAL1 = 3'd1;
    localparam [2:0] RANDOM_FINAL2 = 3'd2;
    localparam [2:0] RANDOM_FINAL3 = 3'd3;
    localparam [2:0] RANDOM_FINAL4 = 3'd4;
    reg [2:0] randomState = RANDOM_INIT;
    reg [31:0] randomY;
    
    task toStageSeed;
    begin
        // Update the seed, set the stage.
        stageIndex <= STAGE_SEED;
        // Initial the values for SEED stage.
        x <= {((in_seed == 32'd0) ? in_globalTime[31:1] : in_seed[31:1]), 1'b1};
        j <= 0;
        left <= 0;
        // Remove the flags.
        flags[FLAG_INITSEED] <= 1'b0;
    end
    endtask
    
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the stage.
            stageIndex <= STAGE_NONE;
            state <= STATE_IDLE;
            flags <= 2'd0;
            fromReloadStage <= 1'b0;
			// Reset the output.
			out_busy <= `OUTPUT_INVALID;
			out_data <= 32'd0;
        end else begin
            if (in_enable) begin
                // Wait and check the state.
                case(state)
                    STATE_IDLE: begin
                        // Update the flags.
                        flags <= {in_next, in_seedReady};
                        // Reset the stage.
                        fromReloadStage <= 1'b0;
                        // Check the flags.
                        if (in_next | in_seedReady) begin
                            // Update the state to check mission.
                            state <= STATE_CHECKING;
							// Being busy.
							out_busy <= `OUTPUT_VALID;
                        end
                    end
                    STATE_CHECKING: begin
                        // Check the flags.
                        if (flags[FLAG_INITSEED]) begin
                            // Update the state to busy.
                            state <= STATE_BUSY;
                            // Work as seed.
                            toStageSeed();
                        end else begin
							// Check the next flag.
                            if (flags[FLAG_NEXT]) begin
                                // Update the stage to busy.
                                state <= STATE_BUSY;
                                // Work as random.
                                stageIndex <= STAGE_RANDOM;
                            end else begin
								// Nothing need to do anymore, back to IDLE state.
								state <= STATE_IDLE;
								// No more busy.
								out_busy <= `OUTPUT_INVALID;
							end
						end
                    end
                    STATE_BUSY: begin
                        case (stageIndex)
                            STAGE_NONE: begin
                                // Reset the from reload flag.
                                fromReloadStage <= 1'b0;
                                fromRandomStage <= 1'b0;
                                // Back to CHECKING stage.
                                state <= STATE_CHECKING;
                            end
                            STAGE_SEED: begin
                                if (j == N) begin
                                    // Set the value to the vector.
                                    vecState[j] <= x;
                                    // Check the flag of the reload.
                                    stageIndex <= fromReloadStage ? STAGE_RELOAD : STAGE_NONE;
									// Clear the seed initial flag.
									flags[FLAG_INITSEED] <= 1'b0;
                                end else begin
                                    // Set the value for all the vector state.
                                    vecState[j] <= x;
                                    // Update x.
                                    x <= x * A;
                                    // Increase the j.
                                    j <= j + 1;
                                end
                            end
                            STAGE_RELOAD: begin
                                // Set the from reload flag.
                                fromReloadStage <= 1'b1;
                                // Check the left.
                                if (left < -1) begin
                                    // Move to stage seed.
                                    toStageSeed();
                                end else begin
                                    // Executing the stage for the reload,
                                    case (reloadState)
                                        RELOAD_INIT  : begin
                                            // Initial the left and next.
                                            left <= N - 1;
                                            nextIndex <= 1;
                                            // Set the s0 and s1.
                                            s0 <= vecState[0];
                                            s1 <= vecState[1];
                                            // Initial the parameter.
                                            p0 <= 0;
                                            p2 <= 2;
                                            pM <= M;
                                            // Initial the loop.
                                            j <= N - M + 1;
                                            // Start the loop.
                                            reloadState <= RELOAD_LOOP1;
                                        end
                                        RELOAD_LOOP1 : begin
                                            // Check j value.
                                            if (j>1) begin
                                                // Start for the loop.
                                                vecState[p0] <= vecState[pM] ^ {1'b0, s0[31], s1[30:1]} ^ (s1[0] ? K : 32'd0);
                                                p0 <= p0 + 1;
                                                pM <= pM + 1;
                                                s0 <= s1;
                                                s1 <= vecState[p2];
                                                p2 <= p2 + 1;
                                                j <= j - 1;
                                            end else begin
                                                // Switch the state.
                                                reloadState <= RELOAD_LOOP2;
                                                // Initial the pM.
                                                pM <= 0;
                                            end
                                        end
                                        RELOAD_LOOP2 : begin
                                            if (j>1) begin
                                                // Start for the loop.
                                                vecState[p0] <= vecState[pM] ^ {1'b0, s0[31], s1[30:1]} ^ (s1[0] ? K : 32'd0);
                                                p0 <= p0 + 1;
                                                pM <= pM + 1;
                                                s0 <= s1;
                                                s1 <= vecState[p2];
                                                p2 <= p2 + 1;
                                                j <= j - 1;
                                            end else begin
                                                // Switch the state.
                                                reloadState <= RELOAD_FINAL1;
                                                // Initial the s1.
                                                s1 <= vecState[0];
                                                vecState[p0] <= vecState[pM] ^ {1'b0, s0[31], vecState[0][30:1]} ^ (vecState[0][0] ? K : 32'd0);
                                            end
                                        end
                                        RELOAD_FINAL1: begin 
                                            // Update the s1.
                                            s1 <= s1 ^ (s1 >> 11);
                                            // Switch the state.
                                            reloadState <= RELOAD_FINAL2;
                                        end
                                        RELOAD_FINAL2: begin 
                                            // Update the s1.
                                            s1 <= s1 ^ ((s1 << 7) & 32'h9D2C5680);
                                            // Switch the state.
                                            reloadState <= RELOAD_FINAL3;
                                        end
                                        RELOAD_FINAL3: begin 
                                            // Update the s1.
                                            s1 <= s1 ^ ((s1 << 15) & 32'hEFC60000);
                                            // Switch the state.
                                            reloadState <= RELOAD_FINAL4;
                                        end
                                        RELOAD_FINAL4: begin
                                            // Output reload result.
                                            reloadResult <= (s1 ^ (s1 >> 18));
                                            // Finish the reload state.
                                            reloadState <= RELOAD_INIT;
                                            // Check the coming flag.
                                            stageIndex <= fromRandomStage ? STAGE_RANDOM : STAGE_NONE;
                                        end
                                    endcase
                                end
                            end
                            STAGE_RANDOM: begin
                                // Set the from random flag.
                                fromRandomStage <= 1'b1;
                                // Check the left data.
                                if (left < 1) begin
                                    // Start reload stage.
                                    stageIndex <= STAGE_RELOAD;
                                    // Initial the reload state.
                                    reloadState <= RELOAD_INIT;
                                end else begin
                                    case (randomState)
                                        RANDOM_INIT: begin
                                            // Get the result from the next data.
                                            randomY <= vecState[nextIndex];
                                            nextIndex <= nextIndex + 1;
                                            // Switch the state.
                                            randomState <= RANDOM_FINAL1;
                                        end
                                        RANDOM_FINAL1: begin
                                            // Update y.
                                            randomY <= randomY ^ (randomY >> 11);
                                            // Switch the state.
                                            randomState <= RANDOM_FINAL2;
                                        end
                                        RANDOM_FINAL2: begin
                                            // Update y.
                                            randomY <= randomY ^ ((randomY << 7) & 32'h9D2C5680);
                                            // Switch the state.
                                            randomState <= RANDOM_FINAL3;
                                        end
                                        RANDOM_FINAL3: begin
                                            // Update y.
                                            randomY <= randomY ^ ((randomY << 15) & 32'hEFC60000);
                                            // Switch the state.
                                            randomState <= RANDOM_FINAL4;
                                        end
                                        RANDOM_FINAL4: begin
                                            // Update the output data.
                                            out_data <= randomY ^ (randomY >> 18);
                                            // Switch the state.
                                            randomState <= RANDOM_INIT;
                                            stageIndex <= STAGE_NONE;
											// Clear the next flag.
											flags[FLAG_NEXT] <= 1'b0;
                                        end
                                    endcase
                                end
                            end
                        endcase
                    end
                endcase
            end
        end
    end
    
endmodule
