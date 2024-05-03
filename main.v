`timesacle 1ns/1ps
// MohammadParsa Dini 400101204
// Logic Circuits Project
//verilog implementation of the circuit 
//aiming to count the rate of heart beats per minute by receiving the heart beat pulses

// first we will create a module named test to manage all the buisiness
module test(heart_pulse, clk, out_lut, stop_buzzer, mute, ONES,TENS,HUNDREDS, _7seg_1, _7seg_2, _7seg_3);
// here our inputs are the hearbeat(x), the clock signal(clk) and the mute button(mute)
input heart_pulse, clk, stop_buzzer, mute;
// here out outputs are the output of lookuptable(out_lut),
// besides the LED and the buzzer and the eight bit binary number of beats/min
// and the inputs to 3 seven segments (ONEs, TENs, HUNDREDS)
output reg [10:0] out_lut;
output reg LED, buzzer;
output reg [7:0] beats;
output reg [7:0] _7seg_1, _7seg_2, _7seg_3;
output reg [3:0] ONES,TENS, HUNDREDS;
// now we will define two variables one is the output of counter and it will
// be reset to zero by reset signal and the other is the exact value of the 
// counter right before the reset
reg [10:0] out_counter = 11b'00000000000;
reg [10:0] temp_counter = 11b'00000000000;
// Here we will define two other variables which they aim to specify the state 
// of the circuit as we defined earlier
reg HeartPulsePosedge = 0;
reg is_stateA = 0;
reg is_stateB =0
reg temp2 =0;
reg is_heartpulse_posedge = 0;

// Now we  will read and set the memory for the lookup table
reg [10:0] memory [2000:0];
initial begin
@readmemb("data.txt",memory) 
 end

// this section of code is concerned with shutting down the buzzer and the LED after 
// 100 ms when the pulse ocurred
@always(*) begin
	temp2 = stop_buzzer;
end 

//Now we wish to count the number of posedges of clk signal to measure the period time
// and determine the instantaneous BPM of heartbeat 
@always(posedge clk) begin
//checking if the current state is A, then a transition to B
//and if the current state is B, then a transition to C and then to A 
//meanwhile we will count the number of clk posedges whithin the period
// and increment temp_counter
	if( !heart_pulse && is_stateA)
		is_stateB =1;
	if( heart_pulse && is_stateB) begin
		is_stateA =0;
		is_stateB =0;
	end
	if( HeartPosedge && !is_stateB) begin
		out_counter = 11b'00000000000;
		is_stateA =1;
	end
	temp_counter = 11b'00000000001 + temp_counter;
end
//Here when we reset before setting temp_counter to zero we will store it 
// into out_counter
@always(posedge heart_pulse) begin
	out_counter = temp_counter;
	is_heartpulse_posedge = 1;
	temp_counter = 11b'00000000001 + temp_counter;
end
// Here we will make LED on for 100 ms after the heart beat pulse 
// and the buzzer will be pon if mute is off and LED is on obviously
assign LED = temp2;
assign buzzer = LED && (!mute);

integer index_lut;
@always(out_counter) begin
	index_lut = out_counter;
end

//assign out_counter = temp_counter;
// here we will make the output of the EPROM (out_lut) in terms of its input
// which is out_counter --> index_lut
assign out_lut = memory[index_lut];
binary_to_bcd btb(BPM,ONES,TENS,HUNDREDS);
bcd7Segment(ONES,_7seg_1);
bcd7Segment(TENS,_7seg_2);
bcd7Segment(HUNDREDS,_7seg_3);
endmodule
// this module will act as an 3 bit full adder
module add3(x,y,s,cin)
input [3:0] x,y;
wire cout;
input cin;
output [3:0] s;
assign {s,cout} = x + y+ cin; 
endmodule
// this module will convert binary to 3 digit BCD code(4 bit) 
module binary_to_bcd(A,ones,tens,hundreds)
	input [7:0] A;
	output [7:0] ones,tens,hundreds;
	wire [3:0] c1,c2,c3,c4,c5,c6,c7;
	wire [3:0] d1,d2,d3,d4,d5,d6,d7;
	assign d1 = {1b'0,A[7:5]};
	assign d2 = {c1[2:0],A[4]};
	assign d3 = {c2[2:0],A[3]};
	assign d4 = {c3[2:0],A[2]};
	assign d5 = {c4[2:0],A[1]};
	assign d6 = {1b'0,c1[3],c2[3],c3[3]};
	assign d7 = {c6[2:0],c4[3]};
	add3 m1(d1,c1);
	add3 m2(d2,c2);
	add3 m3(d3,c3);
	add3 m4(d4,c4);
	add3 m5(d5,c5);
	add3 m6(d6,c6);
	add3 m7(d7,c7);
	assign ones = {c5[2:0],A[0]}
	assign tens = {c7[2:0],c5[3]}
	assign hundreds = {c6[3],c7[3]}
endmodule
// this module will get the bcd code and make an instant of the pinouts of a seven segment
module bcd7Segment(bcd,seg); // HW Code:
	input [3:0] bcd; //initializing bcd as an 4 bit input signal
	output[7:0] seg; //initializing seg as an 8 bit output signal
	reg [7:0] seg; //initializing bcd signal as registers
	always @ (bcd)begin
		case(bcd)
			0: seg = 8'b11000000; //when bcd = 0
			1: seg = 8'b11111001; //when bcd = 1
			2: seg = 8'b10100100; //when bcd = 2
			3: seg = 8'b10110000; //when bcd = 3
			4: seg = 8'b10011001; //when bcd = 4
			5: seg = 8'b10010010; //when bcd = 5
			6: seg = 8'b10000010; //when bcd = 6
			7: seg = 8'b11111000; //when bcd = 7
			8: seg = 8'b10000000; //when bcd = 8
			9: seg = 8'b10010000; //when bcd = 9
			default: seg=8'b11111111; //any other value
		endcase
	end
endmodule