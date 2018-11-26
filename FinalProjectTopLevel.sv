module FinalProjectTopLevel(
	input logic clk, reset, ps2In, ps2clk, snesIn,
	input logic [1:0] sel,
	input logic [2:0] a,
	output logic vsync, hsync,
	output logic[3:0] VGA_R, VGA_G, VGA_B
	);

// internal wires
	logic clk25M, clk500, enable;
	logic [2:0] command, ps2ToMux, snesToMux;
	int Cx, Cy, Ox, Oy, Ow, Oh;

// modules 
	SPI_PS2KB p0(ps2clk, ps2In, ps2ToMux);
	SPI_SNES s0(clk, snesIn, snesToMux);
	multiplexer mux0(a, snesToMux, ps2ToMux, sel, command);
	ObjectLocation L0(~reset, clk500, command, Ox, Oy, Oh, Ow);
	clkDivider #(100000) clk1(clk, ~reset, clk500);
	clkDivider #(2) clk0(clk, ~reset, clk25M);
	XYcounter X0(clk25M, ~reset, vsync, hsync, enable, Cx, Cy);
	RGBcontrol RGB0(enable, Cx, Cy, Ox, Oy, Oh, Ow, VGA_R, VGA_G, VGA_B);
	
	
endmodule
	