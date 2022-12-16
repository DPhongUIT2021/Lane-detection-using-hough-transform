


module comparator2(a, b, gt, lt);
		parameter msb = 1;
		input[msb:0] a, b;
		output gt, lt;
		
		wire a0, a1, b0, b1;
		
		assign a0 = a[0];
		assign a1 = a[1];
		assign b0 = b[0];
		assign b1 = b[1];
		
		assign gt = (a1 & ~b1) | (a0 & ~b1 & ~b0) | (a1 & a0 & ~b0);
		assign lt = (b1 & ~a1) | (~a1 & ~a0 & b0) | (~a0 & b1 & b0);
		
endmodule



