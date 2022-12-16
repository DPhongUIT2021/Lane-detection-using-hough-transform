

module mul2_vedic(A, B, O);
		input[1:0] A, B;
		output[3:0] O;
	
		wire A0B0, A0B1, A1B0, A1B1, s1_cArry, s2_cArry;
		
		assign A0B0 = (A[0] & B[0]);
		assign A0B1 = (A[0] & B[1]);
		assign A1B0 = (A[1] & B[0]);
		assign A1B1 = (A[1] & B[1]);
		
		assign O[0] = A0B0;
		assign O[1] = (A1B0 ^ A0B1);
		assign s1_cArry = (A1B0 & A0B1);
		assign O[2] = (A1B1 ^ s1_cArry);
		assign s2_cArry = (A1B1 & s1_cArry);
		assign O[3] = s2_cArry;

endmodule



