

module mul4_vedic(A, B, O);
		parameter msb = 3;
		
		input[msb:0] A, B;
		output[msb*2+1:0] O;
		
		wire[msb/2:0] A0, A1, B0, B1;
		wire[msb:0] mul_0, mul_1, mul_2, mul_3;
		wire[msb:0] adder0, adder1, adder2;
		wire over0, over1, over01;
		
		mul2_vedic m0(.A(A0), .B(B0), .O(mul_0));
		mul2_vedic m1(.A(A1), .B(B0), .O(mul_1));
		mul2_vedic m2(.A(A0), .B(B1), .O(mul_2));
		mul2_vedic m3(.A(A1), .B(B1), .O(mul_3));
			
		adder4 a0(.A(mul_2), .B(mul_1), .O(adder0), .carry_out(over0));
		adder4 a1(.A(adder0), .B({2'b00, mul_0[msb:msb/2+1]}), .O(adder1), .carry_out(over1));
		adder4 a2(.A(mul_3), .B({1'b0, over01, adder1[msb:msb/2+1]}), .O(adder2), .carry_out());
		
		assign A1 = A[msb:msb/2+1];
		assign A0 = A[msb/2:0];
		assign B1 = B[msb:msb/2+1];
		assign B0 = B[msb/2:0];
		
		assign over01 = (over1 | over0);
		assign O[msb*2+1:0] = {adder2[msb:0], adder1[msb/2:0], mul_0[msb/2:0]};
		
endmodule
































