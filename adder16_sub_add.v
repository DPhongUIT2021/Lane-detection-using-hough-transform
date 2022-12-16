

module adder16_sub_add(A, B, O, ctrl_adder);
	parameter msb = 15;
	input[msb:0] A, B;
	input ctrl_adder;
	output[msb:0] O;
	
	wire[msb-1:0] c;
	wire carry_in, carry_out;
	wire[msb:0] B_xor;
	
	//module full_adder(O, carry_out, a, b, carry_in);
	full_adder f0[15:0](O[msb:0], {carry_out,c[msb-1:0]} , A[msb:0], B_xor[msb:0], {c[msb-1:0], carry_in});
	
	assign B_xor[msb:0] = ({msb+1{ctrl_adder}} ^ B[msb:0]);
	assign carry_in = ctrl_adder;
	
endmodule


