


module adder4(A, B, O, carry_out);
	parameter msb = 3;
	input[msb:0] A, B;
	output[msb:0] O;
	output carry_out;
	
	wire[msb-1:0] c;
	//module full_adder(O, carry_out, a, b, carry_in);
	full_adder f0[3:0](O[msb:0], {carry_out,c[msb-1:0]} , A[msb:0], B[msb:0], {c[msb-1:0], 1'b0});
	
endmodule
