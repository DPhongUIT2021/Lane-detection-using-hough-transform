

module adder8(A, B, O, carry_out);
	parameter msb = 7;
	input[msb:0] A, B;
	wire carry_in = 1'b0;
	output[msb:0] O;
	output carry_out;
	
	wire[msb-1:0] c;
	//module full_adder(O, carry_out, a, b, carry_in);
	full_adder f0[7:0](O[msb:0], {carry_out,c[msb-1:0]} , A[msb:0], B[msb:0], {c[msb-1:0], carry_in});
	
endmodule
