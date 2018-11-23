module multiplexer (
	input logic [2:0] a, b, c,
	input logic [1:0] sel,
	output logic [2:0] z
	);

always_comb
	case(sel)
		0: z = a;
		1: z = b;
		2: z = c;
		default: z = a;
	endcase // sel
endmodule // multiplexer