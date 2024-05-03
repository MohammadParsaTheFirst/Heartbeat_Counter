`timesacle 1ns/1ps
// MohammadParsa Dini 400101204
// Logic Circuits Project
//verilog implementation of the circuit 
//aiming to count the rate of heart beats per minute by receiving the heart beat pulses

// the output to the circuit 
reg heart_pulse, clk, mute=0, stop_buzzer=0;
wire[10:0] out_counter;
wire[7:0] out_lut;
wire LED, buzzer;

integer f =1000;//frequency of the clock 
integer turns = 10;
integer muter_index = 8124;
integer 1microsec = 100000;
integer clk_length;
//Instant from the main.v file in order to managing the signals
test uut(.heart_pulse(heart_pulse), .clk(clk), .out_counter(out_counter),.out_lut(out_lut),
    .mute(mute), .LED(LED), .stop_buzzer(stop_buzzer));
// now making the clk and heart beat signals manually:
//additionally we will mute the buzzer at the 8124th loop
for(integer i =0;i<f*turns;i= i +1) begin
    if(i==muter_index)
        mute = 1;
    clk_length = 1microsec*5;
    // now setting the pause time to produce a clock signal 
    #clk_length clk = 1;
    #clk_length clk =0; 
end

initial begin
    for(i = 0 ; i <f * turns; i++) begin
        #(400*1microsec) heart_pulse = 1;
        #(200*1microsec) heart_pulse = 0;
        #(100*1microsec) stop_buzzer =0;
    end
end

