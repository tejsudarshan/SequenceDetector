`timescale 1ns / 1ps

module SeqDec(sequence_in,clock,reset,detector_out
    );
input clock;
input reset;
input sequence_in;
output reg detector_out;

parameter Zero=3'b000,
One=3'b001,
OneZero=3'b011,
OneZeroOne=3'b010,
OneZeroOneOne=3'b110;
reg[2:0] current_state,next_state;
//sequential memory ,defines state change, so we are goin with clock
always@(posedge clock,posedge reset)
begin
if(reset==1)
current_state <= Zero;
else
current_state <= next_state;
end

//combinational logic
always@(current_state,sequence_in)
begin
case(current_state)
Zero:begin
if(sequence_in==1)
 next_state<=One;
else
 next_state<=Zero;
end
One:begin
if(sequence_in==0)
 next_state<=OneZero;
else
 next_state<=One;
end
OneZero:begin
if(sequence_in==0)
 next_state<=Zero;
else
 next_state<=OneZeroOne;
end
OneZeroOne:begin
if(sequence_in==0)
 next_state<=OneZero;
else
 next_state<=OneZeroOneOne;
end
OneZeroOneOne:begin
if(sequence_in==0)
 next_state<=OneZero;
else
 next_state<=One;
end
default : next_state=Zero; 
endcase
end

always@(current_state)
begin
case(current_state)
Zero: detector_out = 0;
One: detector_out = 0;
OneZero: detector_out = 0;
OneZeroOne: detector_out = 0;
OneZeroOneOne: detector_out = 1;
default: detector_out = 0;
endcase
end
endmodule


///////////////////////////////////////////////////
//test bench
`timescale 1ns / 1ps


module Seqtb;

	// Inputs
	reg sequence_in;
	reg clock;
	reg reset;

	// Outputs
	wire detector_out;

	// Instantiate the Unit Under Test (UUT)
	SeqDec uut (
		.sequence_in(sequence_in), 
		.clock(clock), 
		.reset(reset), 
		.detector_out(detector_out)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		forever #5 clock=~clock;
	   end
		initial begin
    	sequence_in = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
		
		reset = 0;
		sequence_in = 1;
		
	

		// Wait 100 ns for global reset to finish
		#10;
		
		sequence_in = 0;
	
		reset = 0;

		// Wait 100 ns for global reset to finish
		#10;
		
		sequence_in = 1;
		
		reset = 0;

		// Wait 100 ns for global reset to finish
		#10;
		
		sequence_in = 1;
		#10;
			
		
        
		// Add stimulus here

	end
      
endmodule
