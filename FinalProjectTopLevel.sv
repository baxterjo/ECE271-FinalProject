module FinalProjectTopLevel(
	input logic clk, reset,
	output logic vsync, hsync,
	output logic[3:0] VGA_R, VGA_G, VGA_B
	);
	logic clk25,enable;
	int x,y;
	
	clkmodifier M0(clk, ~reset, clk25);
	XYcounter X0(clk25, ~reset, vsync, hsync, enable, x, y);
	RGBcontrol RGB0(enable, x, y, VGA_R, VGA_G, VGA_B);
	
	
endmodule
	