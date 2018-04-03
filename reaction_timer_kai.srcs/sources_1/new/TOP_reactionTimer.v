`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ENGN3213 Assignment 1 Group
// Engineer: Haolei Ye
//           Fangxiao Dong
// 
// Create Date: 2018/03/17 22:52:17
// Design Name: React Timer Top Module
// Module Name: TOP_reactionTimer
// Project Name: Reaction Timer
// Target Devices: Nexys4 DDR
// Tool Versions: Vivado HLx 2017.4
// Description: This is the top module of the entire design. It is only design for
// generating clocks, debouncing buttons and connected outputs.
// 
// Dependencies: 
//    - globalTime
//    - clockDivider
//    - edgeDetector
//    - debouncer
//    - latchDebouncer
//    - reactTimerCpu
//    - ssdDriver
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP_reactionTimer(
    input wire         in_100MHzClock,
    input wire         in_reset,
    input wire         in_enable,
    input wire         in_startButton,
    input wire         in_testButton,
    input wire         in_clearBestButton,
    input wire         in_ledDisable,
    input wire         in_audioDisable,
    input wire         in_triLedDisable,
    output wire [15:0] out_leds,
    output wire [7:0]  out_ssdDigitOutput,
    output wire [7:0]  out_ssdSelector,
    output wire [2:0]  out_triColorLedLeft,
    output wire [2:0]  out_triColorLedRight,
    output wire        out_audioSd,
    output wire        out_audioPwm,
    output wire [2:0]  out_vgaR,
    output wire [2:0]  out_vgaG,
    output wire [2:0]  out_vgaB,
    output wire        out_vgaHs,
    output wire        out_vgaVs);
    
    wire [31:0] globalTimerCounter;
    wire debouncedTestButton, debouncedStartButton, debouncedClearBestButton, clock_1kHz;
    wire [27:0] displayNumber;
    wire [7:0] digitEnable; 
    wire [7:0] displayDots;
    wire clock_1kHzRising;
    
    // Global timer.
    globalTime globalTimer(
        .in_clock(in_100MHzClock),
        .out_time(globalTimerCounter));
    
    // 1kHz clock.
    clockDivider #(
        .THRESHOLD(50_000)
    ) clock1kHz (
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_dividedClock(clock_1kHz));
        
    // 1kHz clock edge detector.
    edgeDetector clockEdge1kHz(
        .in_signal(clock_1kHz),
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(clock_1kHzRising));
    
    // The start button use a normal debouncer.
    debouncer #(
        .PIPELINE_LEVEL(5)
    ) startButtonDebouncer (
        .in_clock(in_100MHzClock),
        .in_enable(clock_1kHz),
        .in_reset(in_reset),
        .in_buttonIn(in_startButton),
        .out_buttonOut(debouncedStartButton)
    );
    
    // The same as the clear best button.
    debouncer #(
        .PIPELINE_LEVEL(5)
    ) clearBestButtonDebouncer (
        .in_clock(in_100MHzClock),
        .in_enable(clock_1kHz),
        .in_reset(in_reset),
        .in_buttonIn(in_clearBestButton),
        .out_buttonOut(debouncedClearBestButton)
    );
    
    // The test button signal goes directly into the latch debouncer.
    latchDebouncer #(
        .INTERVAL(100_000)
    ) testButtonDebouncer (
        .in_clock(in_100MHzClock),
        .in_enable(in_enable),
        .in_reset(in_reset),
        .in_buttonIn(in_testButton),
        .out_buttonOut(debouncedTestButton));
     
     // Add the CPU for the entire framework.
     wire [31:0] ssdOutput;
     wire [7:0]  ssdDots;
     
     reactTimerCpu reactionTimerProcessor(
         .in_globalTime(globalTimerCounter),
         .in_clock(in_100MHzClock),
         .in_reset(in_reset),
         .in_enable(in_enable),
         .in_start(debouncedStartButton),
         .in_test(debouncedTestButton),
         .in_clearBest(debouncedClearBestButton),
         .in_audioEnable(~in_audioDisable),
         .in_ledEnable(~in_ledDisable),
         .in_triColorLedEnable(~in_triLedDisable),
         .out_leds(out_leds),
         .out_triColorLeft(out_triColorLedLeft),
         .out_triColorRight(out_triColorLedRight),
         .out_ssdOutput(ssdOutput),
         .out_ssdDots(ssdDots),
         .out_audioPwm(out_audioPwm),
         .out_audioSd(out_audioSd));
    
    // 7-segments digit panel output.
    ssdDriver ssdDisplayOutput(
        .in_digit7(ssdOutput[31:28]),
        .in_digit6(ssdOutput[27:24]),
        .in_digit5(ssdOutput[23:20]),
        .in_digit4(ssdOutput[19:16]),
        .in_digit3(ssdOutput[15:12]),
        .in_digit2(ssdOutput[11:8]),
        .in_digit1(ssdOutput[7:4]),
        .in_digit0(ssdOutput[3:0]),
        .in_dots(ssdDots),
        .in_clock_1kHz_rising(clock_1kHzRising),
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_digitExpression(out_ssdDigitOutput[6:0]),
        .out_digitDot(out_ssdDigitOutput[7]),
        .out_digitSelector(out_ssdSelector));

    // VGA output
    wire [0:127] vgaCharPixel;
    wire [7:0] vgaDriverReqPosX, vgaDriverReqPosY;
    wire vgaDriverOutR, vgaDriverOutG, vgaDriverOutB; 
    
    vram globalVideoRam(
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
      //.in_updateXPos(),
      //.in_updateYPos(),
      //.in_updateCharAscii(),
      //.in_update(),
        .in_charXPos(vgaDriverReqPosX),
        .in_charYPos(vgaDriverReqPosY),
        .out_charBitmap(vgaCharPixel));
    
    vgaDriver vgaPortDriver(
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_charPixel(vgaCharPixel),
        .out_charXPos(vgaDriverReqPosX),
        .out_charYPos(vgaDriverReqPosY),
        .out_vgaR(vgaDriverOutR),
        .out_vgaG(vgaDriverOutG),
        .out_vgaB(vgaDriverOutB),
        .out_vgaHs(out_vgaHs),
        .out_vgaVs(out_vgaVs));
    
    assign out_vgaR = {vgaDriverOutR, vgaDriverOutR, vgaDriverOutR, vgaDriverOutR};
    assign out_vgaG = {vgaDriverOutG, vgaDriverOutG, vgaDriverOutG, vgaDriverOutG};
    assign out_vgaB = {vgaDriverOutB, vgaDriverOutB, vgaDriverOutB, vgaDriverOutB};
    
endmodule
