


module equal_179(phi_int, eq_179);
		parameter msb_phi = 7;
		input[msb_phi:0] phi_int;
		output eq_179;
		
		// 179 = 0xB3 = 1011_0011
		assign eq_179 = (phi_int[7] & ~phi_int[6] & phi_int[5] & phi_int[4] & ~phi_int[3] & ~phi_int[2]
							& phi_int[1] & phi_int[0]);

endmodule

