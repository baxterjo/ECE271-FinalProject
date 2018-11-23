module RGBcontrol(
	input logic enable,
	input int x,y,
	output logic[3:0] VGA_R, VGA_G, VGA_B
	);
	always_comb
	begin
		if (enable)
		begin
			VGA_R = x % 15;
			VGA_G = y % 15;
			VGA_B = y / 15;
		end
		else
		begin
			VGA_R = 0;
			VGA_G = 0;
			VGA_B = 0;

		end
	end
endmodule // RGBcontrol 