

module sin_cos_i(xi, yi, zi, a_tb, xi1, yi1, zi1);
			parameter msb = 15, shif_num = 1;
			input[msb:0] xi, yi, zi, a_tb;
			output[msb:0] xi1, yi1, zi1;
			
			wire sel_add1, sel_add2, sel_add3, sign_zi;
			wire[msb:0] yi_shif, xi_shif;
			wire[shif_num-1:0] gnd_bit;
			

			assign sign_zi = zi[msb];
			assign sel_add1 = ~sign_zi;
			assign sel_add2 = ~sign_zi;
			assign sel_add3 = sign_zi;
			assign gnd_bit[shif_num-1:0] = {shif_num{1'b0}};
			assign xi_shif[msb:0] = {gnd_bit, xi[msb:shif_num]};
			assign yi_shif[msb:0] = {gnd_bit, yi[msb:shif_num]};
			
			adder16_sub_add add1(.A(zi), .B(a_tb), .O(zi1), .ctrl_adder(sel_add1)); // sel_adder = 0: A + B; 1: A - B
			adder16_sub_add add2(.A(xi), .B(yi_shif), .O(xi1), .ctrl_adder(sel_add2));
			adder16_sub_add add3(.A(yi), .B(xi_shif), .O(yi1), .ctrl_adder(sel_add3));
		
			
endmodule
