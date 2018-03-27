`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2018 13:33:49
// Design Name: 
// Module Name: audioHintOutput
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module is designed to output the audio hint signal. The audio
// output would be a mono channel sine wave. This audio would be played during the
// test phrase until the tester press the button. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module audioHintOutput #(
    parameter integer PLAYING_CLOCK_THRESHOLD = 8000
)(
    input wire        in_100MHzClock,
    input wire        in_reset,
    input wire        in_enable,
    input wire        in_startPlaying,
    input wire        in_stopPlaying,
    output reg        out_debug = 1'b0,
    output reg        out_audioSd = 1'b1,
    output wire       out_audioPwm,
    output reg        out_ledPwm);
    
    // The state of audio playing module.
    /*
     * STATE_IDLE: Wait for the input signal from start playing.
     */
    localparam STATE_IDLE = 1'b0;
    /*
     * STATE_PLAYING: Playing the pre-written sine wave until the stop playing 
     * signal rising.
     */
    localparam STATE_PLAYING = 1'b1;
    // Initial the state to IDLE state.
    reg state = STATE_IDLE;
    
    // Sine wave 1024 sample.
    reg [7:0] sineSample [255:0];
    
    // We have to detect the rising of start playing.
    wire startPlayingRising;
    edgeDetector startPlayingDetector(
        .in_signal(in_startPlaying),
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(startPlayingRising));
        
    wire stopPlayingRising;
    edgeDetector stopPlayingDetector(
        .in_signal(in_stopPlaying),
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(stopPlayingRising));
    
    reg [7:0] currentSampleIndex = 8'd0;
    reg [7:0] currentSample = 16'd0;
    wire increaseSampleIndex, switchSampleRising;
    
    initial begin
        // Read the data from the sine wave table.
        sineSample[0]=8'h80;
        sineSample[1]=8'h83;
        sineSample[2]=8'h86;
        sineSample[3]=8'h89;
        sineSample[4]=8'h8c;
        sineSample[5]=8'h8f;
        sineSample[6]=8'h92;
        sineSample[7]=8'h95;
        sineSample[8]=8'h98;
        sineSample[9]=8'h9b;
        sineSample[10]=8'h9e;
        sineSample[11]=8'ha2;
        sineSample[12]=8'ha5;
        sineSample[13]=8'ha7;
        sineSample[14]=8'haa;
        sineSample[15]=8'had;
        sineSample[16]=8'hb0;
        sineSample[17]=8'hb3;
        sineSample[18]=8'hb6;
        sineSample[19]=8'hb9;
        sineSample[20]=8'hbc;
        sineSample[21]=8'hbe;
        sineSample[22]=8'hc1;
        sineSample[23]=8'hc4;
        sineSample[24]=8'hc6;
        sineSample[25]=8'hc9;
        sineSample[26]=8'hcb;
        sineSample[27]=8'hce;
        sineSample[28]=8'hd0;
        sineSample[29]=8'hd3;
        sineSample[30]=8'hd5;
        sineSample[31]=8'hd7;
        sineSample[32]=8'hda;
        sineSample[33]=8'hdc;
        sineSample[34]=8'hde;
        sineSample[35]=8'he0;
        sineSample[36]=8'he2;
        sineSample[37]=8'he4;
        sineSample[38]=8'he6;
        sineSample[39]=8'he8;
        sineSample[40]=8'hea;
        sineSample[41]=8'heb;
        sineSample[42]=8'hed;
        sineSample[43]=8'hee;
        sineSample[44]=8'hf0;
        sineSample[45]=8'hf1;
        sineSample[46]=8'hf3;
        sineSample[47]=8'hf4;
        sineSample[48]=8'hf5;
        sineSample[49]=8'hf6;
        sineSample[50]=8'hf8;
        sineSample[51]=8'hf9;
        sineSample[52]=8'hfa;
        sineSample[53]=8'hfa;
        sineSample[54]=8'hfb;
        sineSample[55]=8'hfc;
        sineSample[56]=8'hfd;
        sineSample[57]=8'hfd;
        sineSample[58]=8'hfe;
        sineSample[59]=8'hfe;
        sineSample[60]=8'hfe;
        sineSample[61]=8'hff;
        sineSample[62]=8'hff;
        sineSample[63]=8'hff;
        sineSample[64]=8'hff;
        sineSample[65]=8'hff;
        sineSample[66]=8'hff;
        sineSample[67]=8'hff;
        sineSample[68]=8'hfe;
        sineSample[69]=8'hfe;
        sineSample[70]=8'hfe;
        sineSample[71]=8'hfd;
        sineSample[72]=8'hfd;
        sineSample[73]=8'hfc;
        sineSample[74]=8'hfb;
        sineSample[75]=8'hfa;
        sineSample[76]=8'hfa;
        sineSample[77]=8'hf9;
        sineSample[78]=8'hf8;
        sineSample[79]=8'hf6;
        sineSample[80]=8'hf5;
        sineSample[81]=8'hf4;
        sineSample[82]=8'hf3;
        sineSample[83]=8'hf1;
        sineSample[84]=8'hf0;
        sineSample[85]=8'hee;
        sineSample[86]=8'hed;
        sineSample[87]=8'heb;
        sineSample[88]=8'hea;
        sineSample[89]=8'he8;
        sineSample[90]=8'he6;
        sineSample[91]=8'he4;
        sineSample[92]=8'he2;
        sineSample[93]=8'he0;
        sineSample[94]=8'hde;
        sineSample[95]=8'hdc;
        sineSample[96]=8'hda;
        sineSample[97]=8'hd7;
        sineSample[98]=8'hd5;
        sineSample[99]=8'hd3;
        sineSample[100]=8'hd0;
        sineSample[101]=8'hce;
        sineSample[102]=8'hcb;
        sineSample[103]=8'hc9;
        sineSample[104]=8'hc6;
        sineSample[105]=8'hc4;
        sineSample[106]=8'hc1;
        sineSample[107]=8'hbe;
        sineSample[108]=8'hbc;
        sineSample[109]=8'hb9;
        sineSample[110]=8'hb6;
        sineSample[111]=8'hb3;
        sineSample[112]=8'hb0;
        sineSample[113]=8'had;
        sineSample[114]=8'haa;
        sineSample[115]=8'ha7;
        sineSample[116]=8'ha5;
        sineSample[117]=8'ha2;
        sineSample[118]=8'h9e;
        sineSample[119]=8'h9b;
        sineSample[120]=8'h98;
        sineSample[121]=8'h95;
        sineSample[122]=8'h92;
        sineSample[123]=8'h8f;
        sineSample[124]=8'h8c;
        sineSample[125]=8'h89;
        sineSample[126]=8'h86;
        sineSample[127]=8'h83;
        sineSample[128]=8'h80;
        sineSample[129]=8'h7c;
        sineSample[130]=8'h79;
        sineSample[131]=8'h76;
        sineSample[132]=8'h73;
        sineSample[133]=8'h70;
        sineSample[134]=8'h6d;
        sineSample[135]=8'h6a;
        sineSample[136]=8'h67;
        sineSample[137]=8'h64;
        sineSample[138]=8'h61;
        sineSample[139]=8'h5d;
        sineSample[140]=8'h5a;
        sineSample[141]=8'h58;
        sineSample[142]=8'h55;
        sineSample[143]=8'h52;
        sineSample[144]=8'h4f;
        sineSample[145]=8'h4c;
        sineSample[146]=8'h49;
        sineSample[147]=8'h46;
        sineSample[148]=8'h43;
        sineSample[149]=8'h41;
        sineSample[150]=8'h3e;
        sineSample[151]=8'h3b;
        sineSample[152]=8'h39;
        sineSample[153]=8'h36;
        sineSample[154]=8'h34;
        sineSample[155]=8'h31;
        sineSample[156]=8'h2f;
        sineSample[157]=8'h2c;
        sineSample[158]=8'h2a;
        sineSample[159]=8'h28;
        sineSample[160]=8'h25;
        sineSample[161]=8'h23;
        sineSample[162]=8'h21;
        sineSample[163]=8'h1f;
        sineSample[164]=8'h1d;
        sineSample[165]=8'h1b;
        sineSample[166]=8'h19;
        sineSample[167]=8'h17;
        sineSample[168]=8'h15;
        sineSample[169]=8'h14;
        sineSample[170]=8'h12;
        sineSample[171]=8'h11;
        sineSample[172]=8'h0f;
        sineSample[173]=8'h0e;
        sineSample[174]=8'h0c;
        sineSample[175]=8'h0b;
        sineSample[176]=8'h0a;
        sineSample[177]=8'h09;
        sineSample[178]=8'h07;
        sineSample[179]=8'h06;
        sineSample[180]=8'h05;
        sineSample[181]=8'h05;
        sineSample[182]=8'h04;
        sineSample[183]=8'h03;
        sineSample[184]=8'h02;
        sineSample[185]=8'h02;
        sineSample[186]=8'h01;
        sineSample[187]=8'h01;
        sineSample[188]=8'h01;
        sineSample[189]=8'h00;
        sineSample[190]=8'h00;
        sineSample[191]=8'h00;
        sineSample[192]=8'h00;
        sineSample[193]=8'h00;
        sineSample[194]=8'h00;
        sineSample[195]=8'h00;
        sineSample[196]=8'h01;
        sineSample[197]=8'h01;
        sineSample[198]=8'h01;
        sineSample[199]=8'h02;
        sineSample[200]=8'h02;
        sineSample[201]=8'h03;
        sineSample[202]=8'h04;
        sineSample[203]=8'h05;
        sineSample[204]=8'h05;
        sineSample[205]=8'h06;
        sineSample[206]=8'h07;
        sineSample[207]=8'h09;
        sineSample[208]=8'h0a;
        sineSample[209]=8'h0b;
        sineSample[210]=8'h0c;
        sineSample[211]=8'h0e;
        sineSample[212]=8'h0f;
        sineSample[213]=8'h11;
        sineSample[214]=8'h12;
        sineSample[215]=8'h14;
        sineSample[216]=8'h15;
        sineSample[217]=8'h17;
        sineSample[218]=8'h19;
        sineSample[219]=8'h1b;
        sineSample[220]=8'h1d;
        sineSample[221]=8'h1f;
        sineSample[222]=8'h21;
        sineSample[223]=8'h23;
        sineSample[224]=8'h25;
        sineSample[225]=8'h28;
        sineSample[226]=8'h2a;
        sineSample[227]=8'h2c;
        sineSample[228]=8'h2f;
        sineSample[229]=8'h31;
        sineSample[230]=8'h34;
        sineSample[231]=8'h36;
        sineSample[232]=8'h39;
        sineSample[233]=8'h3b;
        sineSample[234]=8'h3e;
        sineSample[235]=8'h41;
        sineSample[236]=8'h43;
        sineSample[237]=8'h46;
        sineSample[238]=8'h49;
        sineSample[239]=8'h4c;
        sineSample[240]=8'h4f;
        sineSample[241]=8'h52;
        sineSample[242]=8'h55;
        sineSample[243]=8'h58;
        sineSample[244]=8'h5a;
        sineSample[245]=8'h5d;
        sineSample[246]=8'h61;
        sineSample[247]=8'h64;
        sineSample[248]=8'h67;
        sineSample[249]=8'h6a;
        sineSample[250]=8'h6d;
        sineSample[251]=8'h70;
        sineSample[252]=8'h73;
        sineSample[253]=8'h76;
        sineSample[254]=8'h79;
        sineSample[255]=8'h7c;
        // Always reset the current sample to sine sample.
        currentSample = sineSample[0];
    end
        
    audioPwmModem #(
        .PLAYING_CLOCK_THRESHOLD(PLAYING_CLOCK_THRESHOLD) 
    ) audioHintPwmModem (
        .in_reset(in_reset),
        .in_enable(in_enable),
        .in_clock(in_100MHzClock),
        .in_audioSample(currentSample),
        .out_switchSample(increaseSampleIndex),
        .out_audioPwmWave(out_audioPwm));

    edgeDetector switchSampleDetector(
        .in_signal(increaseSampleIndex),
        .in_clock(in_100MHzClock),
        .in_reset(in_reset),
        .in_enable(in_enable),
        .out_risingEdge(switchSampleRising));
    
    always @(posedge in_100MHzClock) begin
        out_ledPwm <= out_audioPwm;
    end

    always @(posedge in_100MHzClock) begin
        // Check reset state.
        if (in_reset) begin
            // Reset the state.
            state <= STATE_IDLE;
            // Reset the output.
            currentSampleIndex <= 8'd0;
            currentSample <= sineSample[0];
            out_debug <= 1'b0;
        end else begin
            if (in_enable) begin
                // Check the current state.
                case (state)
                    STATE_IDLE: begin
                        // Waiting for start playing rising.
                        if (startPlayingRising) begin
                            // Move to playing state.
                            state <= STATE_PLAYING;
                            // Reset the sample index to the first sample.
                            currentSampleIndex <= 8'd0;
                            //!DEBUG
                            out_debug <= 1'b1;
                        end
                        // Always reset the current sample to sine sample.
                        currentSample <= sineSample[0];
                    end
                    STATE_PLAYING: begin
                        // Check the stop playing rising.
                        if (stopPlayingRising) begin
                            // Move to idle state.
                            state <= STATE_IDLE;
                            //!DEBUG
                            out_debug <= 1'b0;
                        end else begin
                            // Check the increase signal.
                            if (switchSampleRising) begin
                                //Switch the playing sample.
                                currentSampleIndex <= currentSampleIndex + 1;
                                // The output sample is now determined.
                                currentSample <= sineSample[currentSampleIndex];
                            end
                        end
                    end
                endcase
            end
        end
    end
    
endmodule
