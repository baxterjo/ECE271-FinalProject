module SPI_PS2KB(input logic clock,				// clock given by the PS/2 keyboard
					input logic data_in,				// PS/2 keyboard data input
					output logic [2:0] data			// data output to object location block
);
		logic [10:0] current;
		logic [7:0] stored;
		logic [7:0] prev;
		logic [3:0] count;
		logic started;
		logic parity;
		
		// (W) up --------- mk > 1D (8'b00011101) --- bk > ------ F0 (8'b11110000), 1D
		// (A) left ------- mk > 1C (8'b00011100) --- bk > ------ F0, 1C
		// (S) down ------- mk > 1B (8'b00011011) --- bk > ------ F0, 1B
		// (D) right ------ mk > 23 (8'b00100011) --- bk > ------ F0, 23
		
		// Data inputs are first accepted when clock and data are both driven low (data sends a 
		// 'start' bit, which is always low) and data is actually read at the point when the clock 
		// is low (look at the diagrams in the second link).
		
		// From there, 8 data bits are sent, followed by a PARITY BIT. The parity bit is a little bit complex, 
		// but basically parity is a way to verify that the information is correct. If a given byte has even parity, 
		// the parity bit will be either 1 or zero so that the total number of 1's in the byte and parity bit are even. 
		// Likewise, if the parity for the information transfer/the byte is odd, then the parity bit will be 
		// 1 or zero to make the total number of 1's is odd. When simulating, just make sure the parity bit is driven correctly. 
		
		// Just for the sake of this, we are going to assume EVEN PARITY. Parity bit is zero if the number of 1's in the byte is already even.
		
		// After the parity bit, there is a stop bit. it is always high, bringing the total to 11, or [10:0]: 
		// 1 start bit (low), 8 data bits, 1 parity bit, 1 stop bit (high)
		
		// Bits should be driven on the positive edge of the clock so that they can be read on the negative edge. Again,
		// the diagrams do a great job of explaining this concept visually.
		
		// The "current" sequence, once complete, is stored into "stored", while the sequence that was in "stored" is moved to "prev".
		// This way, the two most recent sequences are almost always available.
		
		
		
		
		always_ff @ (negedge clock) begin
		
			if(((~data_in) || started)) begin     						// enter if data is low or if it's already started
				started <= 1;													// confirm that it has started
				current[count] <= data_in;									// add most recent bit to the next spot in current
				if(data_in == 1 && count > 0 && count < 9) begin	// if 1 add to parity counter for parity check
					parity <= parity + 1;				
				end
				count <= count + 1;								// increment count
				
				if(count == 11) begin					// if count is out of range, begin reset
					started <= 0;							// reset started
					count <= 0;								// reset count
				
					if(current[9] == parity % 2) begin	// if parity bit is correct, continue transfer
						prev <= stored;						// move the latest full byte into previous
						stored <= current[8:1];				// move the recently completed byte, minus start (1 at the beginning) and parity and stop (2 at the end)
						current <= 0;							// reset the the current container
					end	
					
				end
				
			end
			
		end
		

		
		
		always_comb begin
				if(stored == 8'h1D && prev != 8'hF0) begin //up (W) also checks to make sure its not detecting that the key was just released
					data <= 3;
				end
				if(stored == 8'h1C && prev != 8'hF0) begin //left (A) also checks to make sure its not detecting that the key was just released
					data <= 1;
				end
				if(stored == 8'h1B && prev != 8'hF0) begin //down (S) also checks to make sure its not detecting that the key was just released
					data <= 4;
				end
				if(stored == 8'h23 && prev != 8'hF0) begin //right (D) also checks to make sure its not detecting that the key was just released
					data <= 2;
				end
				else begin
					data <=0;
				end
		end

endmodule 
