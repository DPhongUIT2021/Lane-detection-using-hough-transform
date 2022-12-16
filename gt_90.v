
// z UQ2,22

module gt_90(z, gt);
			parameter msb = 23;
			input[msb:0] z;
			output gt;
			
			// Q2,14 assign gt = (z[15] | (z[14] & z[13] & (z[12] | z[11])) | (z[14] & z[13] & ~z[12] & ~z[11] & z[10] & (z[9] | z[8])));
			assign gt = (z[23] | (z[22]&z[21])&(z[20]|z[19]) | (z[22]&z[21]&~z[20]&~z[19]&z[18]&(z[17] | (~z[17]&z[16]))));
endmodule

