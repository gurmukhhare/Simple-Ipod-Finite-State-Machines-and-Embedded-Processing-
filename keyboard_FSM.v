`define initial_state 3'b000
`define forward_play 3'b001
`define forward_pause 3'b010
`define backward_play 3'b011
`define backward_pause 3'b100

`define B 8'h42  
`define D 8'h44 
`define E 8'h45 
`define F 8'h46

`define b 8'h62
`define d 8'h64 
`define e 8'h65 
`define f 8'h66

//defining characters we need for keyboard interaction
module keyboard_FSM(clk,keyboard,start_reading,direction);

input clk;
input[7:0] keyboard;
reg[2:0] next_state;
reg[2:0] current_state;
output reg start_reading;
output reg direction;
//defining inputs and outputs
always@(*) begin
//case statement simply just implementing the logic from fsm diagram
	case(current_state)
		`initial_state: begin
			start_reading=1'b0;
			direction=1'b1;

			if (keyboard==`E||keyboard==`e)
				next_state = `forward_play;
			else if (keyboard==`B||keyboard==`b)
				next_state = `backward_pause;
			else
				next_state = current_state;
		end
		`forward_play: begin //for cases when playing music in normal direction

			start_reading=1'b1;
			direction=1'b1;

			if (keyboard==`B||keyboard==`b) 
				next_state = `backward_play;
			else if (keyboard==`D||keyboard==`d)
				next_state = `forward_pause;
			else 
				next_state = current_state;
		end
		`backward_play: begin //for playing music backwards
			
			start_reading=1'b1;
			direction=1'b0;

			if (keyboard==`F||keyboard==`f) 
				next_state = `forward_play;
			else if (keyboard==`D||keyboard==`d)
				next_state = `backward_pause;
			else 
				next_state = current_state;
		end

		`forward_pause: begin //pause state when previous state was forward play
			start_reading=1'b0;
			direction=1'b1;
			
			if (keyboard==`E||keyboard==`e) 
				next_state = `forward_play;
			else if (keyboard==`B||keyboard==`b)
				next_state = `backward_pause;
			else 
				next_state = current_state;
		end

		`backward_pause: begin //pause state when previous state was backward play
			start_reading=1'b0;
			direction=1'b0;
			
			if (keyboard==`E||keyboard==`e) 
				next_state = `backward_play;
			else if (keyboard==`F||keyboard==`f)
				next_state = `forward_pause;
			else 
				next_state = current_state;
		end
			
		default: begin //default case
			next_state = `initial_state;
			start_reading=1'b0;
			direction=1'b1;
		end
	endcase
end

always@(posedge clk) begin//logic to set next state
		current_state = next_state;
end
endmodule
			

		
				
				