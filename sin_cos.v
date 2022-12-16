
// x0, y0, out_cos, out_sin UQ1,15
// in_z0 Q2_14
module sin_cos(in_z0, out_sin, out_cos);
		parameter msb = 15, x0 = 16'h8000, y0 = 16'h0000, n_block = 13;
		input[msb:0] in_z0;
		output[msb:0] out_sin, out_cos;
		
		wire[msb:0] x_out[0:n_block], y_out[0:n_block], z_out[0:n_block];
		wire[msb:0] a_tb[0:n_block];
		
		sin_cos_i block_0(.xi(x0), .yi(y0), .zi(in_z0), .a_tb(a_tb[0]), .xi1(x_out[0]), .yi1(y_out[0]), .zi1(z_out[0]));
		defparam block_0.shif_num = 0;
		sin_cos_i block_1(.xi(x_out[0]), .yi(y_out[0]), .zi(z_out[0]), .a_tb(a_tb[1]), .xi1(x_out[1]), .yi1(y_out[1]), .zi1(z_out[1]));
		defparam block_1.shif_num = 1;
		sin_cos_i block_2(.xi(x_out[1]), .yi(y_out[1]), .zi(z_out[1]), .a_tb(a_tb[2]), .xi1(x_out[2]), .yi1(y_out[2]), .zi1(z_out[2]));
		defparam block_2.shif_num = 2;
		sin_cos_i block_3(.xi(x_out[2]), .yi(y_out[2]), .zi(z_out[2]), .a_tb(a_tb[3]), .xi1(x_out[3]), .yi1(y_out[3]), .zi1(z_out[3]));
		defparam block_3.shif_num = 3;
		sin_cos_i block_4(.xi(x_out[3]), .yi(y_out[3]), .zi(z_out[3]), .a_tb(a_tb[4]), .xi1(x_out[4]), .yi1(y_out[4]), .zi1(z_out[4]));
		defparam block_4.shif_num = 4;
		sin_cos_i block_5(.xi(x_out[4]), .yi(y_out[4]), .zi(z_out[4]), .a_tb(a_tb[5]), .xi1(x_out[5]), .yi1(y_out[5]), .zi1(z_out[5]));
		defparam block_5.shif_num = 5;
		sin_cos_i block_6(.xi(x_out[5]), .yi(y_out[5]), .zi(z_out[5]), .a_tb(a_tb[6]), .xi1(x_out[6]), .yi1(y_out[6]), .zi1(z_out[6]));
		defparam block_6.shif_num = 6;
		sin_cos_i block_7(.xi(x_out[6]), .yi(y_out[6]), .zi(z_out[6]), .a_tb(a_tb[7]), .xi1(x_out[7]), .yi1(y_out[7]), .zi1(z_out[7]));
		defparam block_7.shif_num = 7;
		sin_cos_i block_8(.xi(x_out[7]), .yi(y_out[7]), .zi(z_out[7]), .a_tb(a_tb[8]), .xi1(x_out[8]), .yi1(y_out[8]), .zi1(z_out[8]));
		defparam block_8.shif_num = 8;
		sin_cos_i block_9(.xi(x_out[8]), .yi(y_out[8]), .zi(z_out[8]), .a_tb(a_tb[9]), .xi1(x_out[9]), .yi1(y_out[9]), .zi1(z_out[9]));
		defparam block_9.shif_num = 9;
		sin_cos_i block_10(.xi(x_out[9]), .yi(y_out[9]), .zi(z_out[9]), .a_tb(a_tb[10]), .xi1(x_out[10]), .yi1(y_out[10]), .zi1(z_out[10]));
		defparam block_10.shif_num = 10;
		sin_cos_i block_11(.xi(x_out[10]), .yi(y_out[10]), .zi(z_out[10]), .a_tb(a_tb[11]), .xi1(x_out[11]), .yi1(y_out[11]), .zi1(z_out[11]));
		defparam block_11.shif_num = 11;
		sin_cos_i block_12(.xi(x_out[11]), .yi(y_out[11]), .zi(z_out[11]), .a_tb(a_tb[12]), .xi1(x_out[12]), .yi1(y_out[12]), .zi1(z_out[12]));
		defparam block_12.shif_num = 12;
		sin_cos_i block_13(.xi(x_out[12]), .yi(y_out[12]), .zi(z_out[12]), .a_tb(a_tb[13]), .xi1(x_out[13]), .yi1(y_out[13]), .zi1(z_out[13]));
		defparam block_13.shif_num = 13;
		
assign a_tb[0] = 16'b 0011001001000011; // hex=0x3243      Radians[0]=0.78539816339745
assign a_tb[1] = 16'b 0001110110101100; // hex=0x1DAC      Radians[1]=0.46364760900081
assign a_tb[2] = 16'b 0000111110101101; // hex=0x0FAD      Radians[2]=0.24497866312686     
assign a_tb[3] = 16'b 0000011111110101; // hex=0x07F5      Radians[3]=0.12435499454676     
assign a_tb[4] = 16'b 0000001111111110; // hex=0x03FE      Radians[4]=0.06241880999596     
assign a_tb[5] = 16'b 0000000111111111; // hex=0x01FF      Radians[5]=0.03123983343027     
assign a_tb[6] = 16'b 0000000011111111; // hex=0x00FF      Radians[6]=0.01562372862048     
assign a_tb[7] = 16'b 0000000001111111; // hex=0x007F      Radians[7]=0.0078123410601      
assign a_tb[8] = 16'b 0000000000111111; // hex=0x003F      Radians[8]=0.00390623013197     
assign a_tb[9] = 16'b 0000000000011111; // hex=0x001F      Radians[9]=0.00195312251648     
assign a_tb[10] = 16'b 0000000000001111; // hex=0x000F      Radians[10]=0.00097656218956   
assign a_tb[11] = 16'b 0000000000000111; // hex=0x0007      Radians[11]=0.00048828121119   
assign a_tb[12] = 16'b 0000000000000011; // hex=0x0003      Radians[12]=0.00024414062015   
assign a_tb[13] = 16'b 0000000000000001; // hex=0x0001      Radians[13]=0.00012207031189 
		
		assign out_sin[msb:0] = y_out[n_block];
		assign out_cos[msb:0] = x_out[n_block];
		
endmodule

