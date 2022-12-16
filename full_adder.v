
module full_adder(sum, c_out, a, b, c_in);
	input c_in, a, b;
	output sum, c_out;
	
	/* 
	sum = a xor b xor c_in
	carry_out = ab + carry_in(a xor b)
	*/
	
	wire axb, ab, cin_axb;
	
	xor xor_sum(sum, axb, c_in);
	
	xor xor_ab(axb, a , b);
	and and_ab(ab, a , b);
	
	and and_cin_axb(cin_axb, axb, c_in);
	
	or or_cout(c_out, cin_axb, ab);
	
endmodule


	
	
	
	
	
	

	
	
	
	
	
	