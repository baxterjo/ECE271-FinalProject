module SNES_SPID(input logic clock,				// system clock
					input logic data_in,
					output logic [2:0] data		// data output to object location block
);
		logic [3:0] value;
		logic [8:0] count;
		logic [11:0] SNEScount;
		logic SNESclock;
		logic pin3pulse;

		
		
		//  6 microseconds per flip for buttons (16 data pulses are 50% duty with 12 microseconds per full cycle, 
		//  ergo they flip twice per cycle, ergo the clock should flip its value every 6 microseconds)
		
		//  50 MHz, or 50,000,000Hz goes into 6 microseconds (166,666Hz) 300 times, so every 300 cycles 
		//  of system clock, SNES clock flips
		
		//  Correction, this must be 150 since there is a 6 microsecond delay after the data latch pulse. 
		//  To make a 6 microsecond delay, we need a clock that flips every 3 microseconds, generating a 
		//  posedge every 6. That's why numbers are doubled. Also helps make the 50% duty stipulation.
		
		//  Every 60 Hz, there needs to be a reset and a pulse lasting 12 microseconds (1 full cycle). 
		//  166,666 Hz goes into 60Hz 2777.7777 times, or 2778 (now 5556) for this purpose. Every 2778 (5556) cycles of 
		//  SNESclock, the cycle will repeat.

		//  Data_in is the serialized output of the SNES controller. It is driven high during all 16 of the cycles, 
		//  and if it is low during a cycle, it means that the corresponding button is being pressed.
		
		always_ff @ (posedge clock) begin
			if(count == 150) begin
				count <= 0;
				SNESclock <= ~SNESclock;
			end
			else begin
				count <= count + 1;
			end
		end
		
		always_ff @ (posedge SNESclock) begin
			SNEScount <= SNEScount + 1;

			if(SNEScount == 1) begin  // 12 microsecond pulse
				pin3pulse <= 1;
			end
			else if(SNEScount == 3) begin   //6 microsecond delay
				pin3pulse <= 0;
				value <= 0;
				data_in <= 1;
			end
			
			//4 is cycle 1
			//6 is cycle 2
			//8 is cycle 3
			//10 is cycle 4
			
			else if((SNEScount == 12) && ~data_in) begin			//12 is cycle 5, during which the joypad up input is sampled
				value <= value + 1;
			end
			else if((SNEScount == 14) && ~data_in) begin			//14 is cycle 6, during which the joypad down input is sampled
				value <= value + 2;
			end
			else if((SNEScount == 16) && ~data_in) begin			//16 is cycle 7, during which the joypad left input is sampled
				value <= value + 4;
			end
			else if((SNEScount == 18) && ~data_in) begin		//18 is cycle 8, during which the joypad right input is sampled
				value <= value + 8;
			end
			
			//20 is cycle 9
			//22 is cycle 10
			//24 is cycle 11
			//26 is cycle 12
			//28 is cycle 13
			//30 is cycle 14
			//32 is cycle 15
			//34 is cycle 16
			
			else if(SNEScount == 36) begin
				data_in <= 0;
			end
			else if(SNEScount == 5556) begin     //5556 is the 60Hz, 16.67ms reset count
				SNEScount <= 0;
			end
			
		end
		
		always_comb begin
			case(value)
				1: data <= 3;	// move up
				2: data <= 4;  // move down
				4: data <= 1;  // move left
				8: data <= 2;  // move right
				
				default: data <= 0; // if multiple buttons are pressed, it defaults to no movement.
			endcase
		end

endmodule 
