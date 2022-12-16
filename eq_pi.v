


// pi.bin= 11.001001_0000111111011010 pi.hex= 0xC90FDA UQ2,22= 3.141592502593994

module eq_pi(phi, eq_pi);
		parameter msb_pi = 23;
		input[msb_pi:0] phi;
		
		output eq_pi;
		
		assign eq_pi = (phi[23] & phi[22] & ~phi[21] & ~phi[20] & phi[19] & ~phi[18] & ~phi[17] & phi[16]);


endmodule

