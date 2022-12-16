

module image_canny(clk, x, y, reset, inc_address, end_point, cnt_xy);
			parameter msb_point_xy_canny = 59, n_end_point = 30, msb_cnt_xy = 7, msb_point = 15;
			
			input reset, inc_address, clk;
			
			output[msb_point:0] x, y;
			output end_point;
			output[msb_cnt_xy:0] cnt_xy;

			wire[msb_point:0] point_x[0:msb_point_xy_canny];
			wire[msb_point:0] point_y[0:msb_point_xy_canny];
			reg[msb_cnt_xy:0] cnt_xy;
			
			always @(negedge clk) begin
					if(reset) cnt_xy <= 8'b0;
					else if(inc_address) cnt_xy <= cnt_xy + 1;
			end
			
//  ============(d1) y = -8x/5 + 800  (r,phi) = (424, 32)==============
assign point_x[0]=16'h0000; assign point_y[0]=16'h3200; // x[0]=0    y[0]=800
assign point_x[1]=16'h0320; assign point_y[1]=16'h2D00; // x[1]=50    y[1]=720
assign point_x[2]=16'h0640; assign point_y[2]=16'h2800; // x[2]=100    y[2]=640
assign point_x[3]=16'h0960; assign point_y[3]=16'h2300; // x[3]=150    y[3]=560
assign point_x[4]=16'h0C80; assign point_y[4]=16'h1E00; // x[4]=200    y[4]=480
assign point_x[5]=16'h0FA0; assign point_y[5]=16'h1900; // x[5]=250    y[5]=400
assign point_x[6]=16'h12C0; assign point_y[6]=16'h1400; // x[6]=300    y[6]=320
assign point_x[7]=16'h15E0; assign point_y[7]=16'h0F00; // x[7]=350    y[7]=240
assign point_x[8]=16'h1900; assign point_y[8]=16'h0A00; // x[8]=400    y[8]=160
assign point_x[9]=16'h1C20; assign point_y[9]=16'h0500; // x[9]=450    y[9]=80
//  ============(d2) y2 = -5*x/3 + 500    (r, phi) = (257, 31)==============
assign point_x[10]=16'h0000; assign point_y[10]=16'h1F40; // x[10]=0    y[10]=500
assign point_x[11]=16'h01E0; assign point_y[11]=16'h1C20; // x[11]=30    y[11]=450
assign point_x[12]=16'h03C0; assign point_y[12]=16'h1900; // x[12]=60    y[12]=400
assign point_x[13]=16'h05A0; assign point_y[13]=16'h15E0; // x[13]=90    y[13]=350
assign point_x[14]=16'h0780; assign point_y[14]=16'h12C0; // x[14]=120    y[14]=300
assign point_x[15]=16'h0960; assign point_y[15]=16'h0FA0; // x[15]=150    y[15]=250
assign point_x[16]=16'h0B40; assign point_y[16]=16'h0C80; // x[16]=180    y[16]=200
assign point_x[17]=16'h0D20; assign point_y[17]=16'h0960; // x[17]=210    y[17]=150
assign point_x[18]=16'h0F00; assign point_y[18]=16'h0640; // x[18]=240    y[18]=100
assign point_x[19]=16'h10E0; assign point_y[19]=16'h0320; // x[19]=270    y[19]=50
//  ============(d3) Random ==============
assign point_x[20]=16'h2B40;  assign point_y[20]=16'h0120; // x[20]=692    y[20]=18
assign point_x[21]=16'h3870;  assign point_y[21]=16'h3AE0; // x[21]=903    y[21]=942
assign point_x[22]=16'h0590;  assign point_y[22]=16'h02E0; // x[22]=89    y[22]=46
assign point_x[23]=16'h0270;  assign point_y[23]=16'h1BA0; // x[23]=39    y[23]=442
assign point_x[24]=16'h30F0;  assign point_y[24]=16'h0C30; // x[24]=783    y[24]=195
assign point_x[25]=16'h06A0;  assign point_y[25]=16'h3560; // x[25]=106    y[25]=854
assign point_x[26]=16'h10E0;  assign point_y[26]=16'h1540; // x[26]=270    y[26]=340
assign point_x[27]=16'h0F60;  assign point_y[27]=16'h24C0; // x[27]=246    y[27]=588
assign point_x[28]=16'h1850;  assign point_y[28]=16'h37D0; // x[28]=389    y[28]=893
assign point_x[29]=16'h2D10;  assign point_y[29]=16'h25E0; // x[29]=721    y[29]=606

//  ================= Image 2 ============================================

//  ============(d4) y = -5*x/3 + 500    (r, phi) = (257, 31)==============
assign point_x[30]=16'h0000; assign point_y[30]=16'h1F40; // x[30]=0    y[30]=500
assign point_x[31]=16'h01E0; assign point_y[31]=16'h1C20; // x[31]=30    y[31]=450
assign point_x[32]=16'h03C0; assign point_y[32]=16'h1900; // x[32]=60    y[32]=400
assign point_x[33]=16'h05A0; assign point_y[33]=16'h15E0; // x[33]=90    y[33]=350
assign point_x[34]=16'h0780; assign point_y[34]=16'h12C0; // x[34]=120    y[34]=300
assign point_x[35]=16'h0960; assign point_y[35]=16'h0FA0; // x[35]=150    y[35]=250
assign point_x[36]=16'h0B40; assign point_y[36]=16'h0C80; // x[36]=180    y[36]=200
assign point_x[37]=16'h0D20; assign point_y[37]=16'h0960; // x[37]=210    y[37]=150
assign point_x[38]=16'h0F00; assign point_y[38]=16'h0640; // x[38]=240    y[38]=100
assign point_x[39]=16'h10E0; assign point_y[39]=16'h0320; // x[39]=270    y[39]=50
//  ============(d5) y5 = 7x/10 + 100    (r, phi) = (145.00, 57.35)==============
assign point_x[40]=16'h0000; assign point_y[40]=16'h0640; // x[40]=0    y[40]=100
assign point_x[41]=16'h0640; assign point_y[41]=16'h0AA0; // x[41]=100    y[41]=170
assign point_x[42]=16'h0C80; assign point_y[42]=16'h0F00; // x[42]=200    y[42]=240
assign point_x[43]=16'h12C0; assign point_y[43]=16'h1360; // x[43]=300    y[43]=310
assign point_x[44]=16'h1900; assign point_y[44]=16'h17C0; // x[44]=400    y[44]=380
assign point_x[45]=16'h1F40; assign point_y[45]=16'h1C20; // x[45]=500    y[45]=450
assign point_x[46]=16'h2580; assign point_y[46]=16'h2080; // x[46]=600    y[46]=520
assign point_x[47]=16'h2BC0; assign point_y[47]=16'h24E0; // x[47]=700    y[47]=590
assign point_x[48]=16'h3200; assign point_y[48]=16'h2940; // x[48]=800    y[48]=660
assign point_x[49]=16'h3840; assign point_y[49]=16'h2DA0; // x[49]=900    y[49]=730
//  ============(d6) Random ==============
assign point_x[50]=16'h1CE0;  assign point_y[50]=16'h0FD0; // x[50]=462    y[50]=253
assign point_x[51]=16'h2E60;  assign point_y[51]=16'h0C60; // x[51]=742    y[51]=198
assign point_x[52]=16'h0630;  assign point_y[52]=16'h2240; // x[52]=99    y[52]=548
assign point_x[53]=16'h3730;  assign point_y[53]=16'h1750; // x[53]=883    y[53]=373
assign point_x[54]=16'h0E10;  assign point_y[54]=16'h2B00; // x[54]=225    y[54]=688
assign point_x[55]=16'h2240;  assign point_y[55]=16'h29A0; // x[55]=548    y[55]=666
assign point_x[56]=16'h3DB0;  assign point_y[56]=16'h3460; // x[56]=987    y[56]=838
assign point_x[57]=16'h02E0;  assign point_y[57]=16'h0A90; // x[57]=46    y[57]=169
assign point_x[58]=16'h3C70;  assign point_y[58]=16'h2550; // x[58]=967    y[58]=597
assign point_x[59]=16'h39D0;  assign point_y[59]=16'h08E0; // x[59]=925    y[59]=142




			assign x = point_x[cnt_xy];
			assign y = point_y[cnt_xy];
			assign end_point = (cnt_xy == n_end_point) ? 1 : 0;
endmodule

