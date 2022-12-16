

module mul8_vedic(A, B, O);
		parameter msb = 7;
		parameter gnd_msk4 = 4'b0000, gnd_msk3 = 3'b000;
		input[msb:0] A, B;
		output[msb*2+1:0] O;
		
		wire[msb:0] mul_0, mul_1, mul_2, mul_3;
		wire[msb:0] adder0, adder1, adder2;
		wire over0, over1, over2;
		wire[msb/2:0] A1, A0, B1, B0;
		
		mul4_vedic m0(.A(A0), .B(B0), .O(mul_0));
		mul4_vedic m1(.A(A1), .B(B0), .O(mul_1));
		mul4_vedic m2(.A(A0), .B(B1), .O(mul_2));
		mul4_vedic m3(.A(A1), .B(B1), .O(mul_3));
		
	   adder8 a0(.A(mul_2), .B(mul_1), .O(adder0), .carry_out(over0));
		adder8 a1(.A(adder0), .B({gnd_msk4, mul_0[msb:msb/2+1]}), .O(adder1),.carry_out(over1));
		adder8 a2(.A(mul_3), .B({gnd_msk3, over2, adder1[msb:msb/2+1]}), .O(adder2), .carry_out());
		
		assign A1 = A[msb:msb/2+1];
		assign A0 = A[msb/2:0];
		assign B1 = B[msb:msb/2+1];
		assign B0 = B[msb/2:0];
		
		assign over2 = (over1 | over0);
		assign O[msb*2+1:0] = {adder2[msb:0], adder1[msb/2:0], mul_0[msb/2:0]};


endmodule

