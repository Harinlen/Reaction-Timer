`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/31 03:44:45
// Design Name: Mersenne Twister MT19937 implementation random number generator
// Module Name: randMt19937
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module randMt19937(
    input wire [31:0] in_globalTime,
    input wire [31:0] in_seed,
    input wire        in_seedReady,
    input wire        in_next,
    input wire        in_clock,
    input wire        in_reset,
    input wire        in_enable,
    output reg [31:0] out_data = 32'd0,
    output reg        out_busy = 1'b0);

    // State register
    localparam [1:0] STATE_IDLE = 2'd0;
    localparam [1:0] STATE_CHECKING = 2'd1;
    localparam [1:0] STATE_SEED = 2'd2;
    reg [1:0] state = STATE_IDLE, stateNext;
    // Mission register.
    localparam FLAG_SEED = 0;
    localparam FLAG_NEXT = 1;
    reg [1:0] flags = 2'd0;
    // MT19937 vectors.
    reg [31:0] mtVector [623:0];
    reg [31:0] mtSave = 0, mtSaveNext;
    reg [9:0] mti = 625, mtiNext;
    // Shift registers.
    reg [31:0] y1, y2, y3, y4, y5;
    // Array memory write parameters.
    reg [9:0] mtWritePosition;
    reg [31:0] mtWriteData;
    reg mtWriteEnable;
    // Assignment round parameters.
    reg [9:0] mtRoundAPosition = 0, mtRoundAPositionNext;
    reg [31:0] mtRoundAData = 0;
    reg [9:0] mtRoundBPosition = 0, mtRoundBPositionNext;
    reg [31:0] mtRoundBData = 0;
    reg [31:0] product = 0, productNext;
    reg [31:0] factor1 = 0, factor1Next;
    reg [31:0] factor2 = 0, factor2Next;
    reg [4:0] mulCnt = 0, mulCntNext;
    // Output data.
    reg [31:0] outDataNext;
    reg outDataValidNext;
    reg outDataValid = 1'b0;

    // Move to SEED STATE.
    task toSeedState;
        input [31:0] saveNextValue;
        input [9:0] writePosition;
        input [9:0] mtiNextValue;
    begin
        mtSaveNext = saveNextValue;
        productNext = 0;
        factor1Next = mtSaveNext ^ (mtSaveNext >> 30);
        factor2Next = 32'd1812433253;
        mulCntNext = 31;
        mtWriteData = mtSaveNext;
        mtWritePosition = writePosition;
        mtWriteEnable = 1;
        mtiNext = mtiNextValue;
        stateNext = STATE_SEED;
    end
    endtask

    task executeNext;
        input [9:0] mtiNextValue;
        input [9:0] mtRoundAPositionNextValue;
        input [9:0] mtRoundBPositionNextValue;
    begin
        mtiNext = mtiNextValue;
        mtRoundAPositionNext = mtRoundAPositionNextValue;
        mtRoundBPositionNext = mtRoundBPositionNextValue;
        mtSaveNext = mtRoundAData;
        y1 = {mtSave[31], mtRoundAData[30:0]};
        y2 = mtRoundBData ^ (y1 >> 1) ^ (y1[0] ? 32'h9908b0df : 32'h0);
        y3 = y2 ^ (y2 >> 11);
        y4 = y3 ^ ((y3 << 7) & 32'h9d2c5680);
        y5 = y4 ^ ((y4 << 15) & 32'hefc60000);
        outDataNext = y5 ^ (y5 >> 18);
        outDataValidNext = 1;
        mtWriteData = y2;
        mtWritePosition = mti;
        mtWriteEnable = 1;
        stateNext = STATE_IDLE;
    end
    endtask

    always @(*) begin
        // Latch the next state.
        mtSaveNext = mtSave;
        mtiNext = mti;
        // Reset the write data
        mtWriteData = 0;
        mtWritePosition = 0;
        mtWriteEnable = 0;
        // Execute the pipeline.
        mtRoundAPositionNext = mtRoundAPosition;
        mtRoundBPositionNext = mtRoundBPosition;
        productNext = product;
        factor1Next = factor1;
        factor2Next = factor2;
        mulCntNext = mulCnt;
        outDataNext = out_data;
        outDataValidNext = outDataValid & ~in_next;
    
        case (state)
            STATE_IDLE: begin
                // Checking current state.
                if (in_seedReady) begin
                    // Update the state.
                    toSeedState(((in_seed == 32'd0) ? in_globalTime : in_seed), 0, 1);
                end else if (in_next) begin
                    if (mti == 625) begin
                        // Reset the seed state.
                        toSeedState(in_globalTime, 0, 1);
                    end else begin
                        executeNext(((mti < 623) ? (mti + 1) : 0),
                                    ((mtRoundAPosition < 623) ? (mtRoundAPosition + 1) : 0),
                                    ((mtRoundBPosition < 623) ? (mtRoundBPosition + 1) : 0));
                    end
                end else begin
                    // No more mission, back to idle state.
                    stateNext = STATE_IDLE;
                end
            end
            STATE_SEED: begin
                if (mulCnt == 0) begin
                    if (mti < 624) begin
                        toSeedState((product + mti), mti, mti + 1);
                        mtRoundAPositionNext = 0;
                    end else begin
                        // Execute next.
                        executeNext(1, 2, 398);
                    end
                end else begin
                    mulCntNext = mulCnt - 1;
                    factor1Next = factor1 << 1;
                    factor2Next = factor2 >> 1;
                    if (factor2[0]) productNext = product + factor1;
                    stateNext = STATE_SEED;
                end
            end
        endcase
    end

    always @(posedge in_clock) begin
        // Check the reset signal.
        if (in_reset) begin
            // Reset the parameters.
            state <= STATE_IDLE;
            mti <= 625;
            mtRoundAPosition <= 0;
            mtRoundBPosition <= 0;
            product <= 0;
            factor1 <= 0;
            factor2 <= 0;
            mulCnt <= 0;
            out_data <= 0;
            outDataValid <= 0;
            out_busy <= 0;
        end else begin
            if (in_enable) begin
                // Executing the pipeline.
                state <= stateNext;
    
                mtSave = mtSaveNext;
                mti <= mtiNext;
    
                mtRoundAPosition <= mtRoundAPositionNext;
                mtRoundBPosition <= mtRoundBPositionNext;
    
                product <= productNext;
                factor1 <= factor1Next;
                factor2 <= factor2Next;
                mulCnt <= mulCntNext;
    
                out_data <= outDataNext;
                outDataValid <= outDataValidNext;
    
                out_busy <= stateNext != STATE_IDLE;
    
                if (mtWriteEnable) begin
                    mtVector[mtWritePosition] <= mtWriteData;
                end
    
                mtRoundAData <= mtVector[mtRoundAPositionNext];
                mtRoundBData <= mtVector[mtRoundBPositionNext];
            end
        end
    end
endmodule