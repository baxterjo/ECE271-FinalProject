module RGBcontrol(
	input logic enable,
	input int Cx, Cy, Ox, Oy, Oh, Ow,
	output logic[3:0] VGA_R, VGA_G, VGA_B
	);
	always_comb
	begin
		if (enable)
		begin
			if (Cx > Ox && Cx < (Ox + Ow) && Cy > Oy && Cy < (Oy + Oh))
			begin
				VGA_R = Cx % 15;
				VGA_G = Cy % 15;
				VGA_B = Cy / 15;
			end
			else 
			begin
				VGA_R = 247*15/255;
				VGA_G = 131*15/255;
				VGA_B = 0;
			end
		end
		else
		begin
			VGA_R = 0;
			VGA_G = 0;
			VGA_B = 0;

		end
	end
endmodule // RGBcontrol 