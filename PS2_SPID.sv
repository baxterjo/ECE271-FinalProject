module PS2_SPID(input logic clock,				// clock given by the PS/2 keyboard
					input logic data_in,				// PS/2 keyboard data input
					output logic [2:0] data			// data output to object location block
);
		logic [10:0] stored;
		logic [7:0] prev;
		logic [3:0] count;
		logic started;
		
		// (W) up --------- mk > 1D (8'b00011101) --- bk > ------ F0 (8'b11110000), 1D
		// (A) left ------- mk > 1C (8'b00011100) --- bk > ------ F0, 1C
		// (S) down ------- mk > 1B (8'b00011011) --- bk > ------ F0, 1B
		// (D) right ------ mk > 23 (8'b00100011) --- bk > ------ F0, 23
		
		
		always_ff @ (posedge clock) begin
			if(((~clock && ~data_in) || started)) begin
				started <= 1;
				stored[count] <= data_in;
				count <= count + 1;
				if(count == 11) begin
					started <= 0;
					count <= 0;
					prev <= stored[8:1];
					stored <= 0;
				end
			end
		end
		

		
		
		always_comb begin
				if(stored[8:1] == 8'h1D && prev != 8'hF0) begin //up (W)
					data <= 3;
				end
				if(stored[8:1] == 8'h1C && prev != 8'hF0) begin //left (A)
					data <= 1;
				end
				if(stored[8:1] == 8'h1B && prev != 8'hF0) begin //down (S)
					data <= 4;
				end
				if(stored[8:1] == 8'h23 && prev != 8'hF0) begin //right (D)
					data <= 2;
				end
				else begin
					data <=0;
				end
		end

endmodule 
