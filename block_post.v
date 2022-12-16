

module block_post(clk, reset, ctrl, mul, add_pre, j_inc, gt_90, cos, sin, x0, y0, j_out, gt_90_post, R2, R3, j_gt_1000, xi, yi);
			parameter  msb_ctrl_post = 10, msb_mul = 31, msb_add_pre = 23, msb_sin_cos = 15, msb_xi_yi = 11
			, msb_xy = 15, msb_j = 11, y_max = 1000, x_max = 1000, j_min = 12'hBE8, j_max = 12'h3E8;
			input[msb_ctrl_post:0] ctrl;
			input clk, reset;
			input[msb_mul:0] mul;
			input[msb_add_pre:0] add_pre;
		   input[msb_j:0] j_inc;
			input gt_90;
			input[15:0] R2, R3;
			
			output[msb_sin_cos:0] sin, cos;
			output[msb_xy:0] x0, y0;
			output[msb_j:0] j_out;
			output gt_90_post;
			output j_gt_1000;
			output[msb_xi_yi:0] xi, yi;
			
			reg gt_90_post;
			reg[msb_xy:0] x0, y0;
			reg[msb_xi_yi:0] xi, yi;
			reg[msb_sin_cos:0] sin, cos;
			reg[msb_j:0] j;
			reg image[0:y_max][0:x_max];
			integer m, n;
			
			wire wgt90, wcos, wsin, wx0, wy0, wj, reset_j, wj_sign, wxi, wyi, we;
			wire[msb_sin_cos:0] in_sin, in_cos;
			wire[msb_xy:0] in_x0, in_y0;
			wire[msb_xi_yi:0] in_xi, in_yi;
			wire j_eq_0;
			
			assign {wgt90, wcos, wsin, wx0, wy0, wj, reset_j, wj_sign, wxi, wyi, we} = ctrl[msb_ctrl_post:0];
			assign in_x0 = R2;
			assign in_y0 = R3;
			assign in_cos = R2;
			assign in_sin = R3;
			assign in_xi = add_pre[msb_add_pre:12];
			assign in_yi = add_pre[msb_add_pre:12];
			assign j_out = j;
			assign j_gt_1000 = ( j[11] & j[10] | (j[9] & j[8] & j[7] & j[6] & j[5] & (j[4] | (j[3] & (j[2] | j[1] | j[0] )))));
			assign j_eq_0 = (~j[0] & ~j[1] & ~j[2] & ~j[3] & ~j[4] & ~j[5] & ~j[6] & ~j[7] & ~j[8] & ~j[9] & ~j[10]);
			
			
			always @(posedge clk) begin
				  if(reset) begin
							xi <= 12'hFFF; // -1
							yi <= 12'hFFF;	// -1
						   for(m = 0; m <= y_max; m = m + 1) begin
									   for(n = 0; n <= x_max; n = n + 1) begin
													image[m][n] = 0;
								      end
						   end
					end
					else if(reset_j) j <= j_min;
					else begin
							if(wxi) xi <= in_xi;
							if(wyi) yi <= in_yi;
							if(wj_sign & j_eq_0) j[msb_j] <= 1'b0;
							if(wj) j[msb_j-1:0] <= j_inc[msb_j-1:0];
					end
			end
			
			always @(wcos, wsin, wx0, wy0, wgt90, we) begin
						if(wgt90) gt_90_post <= gt_90;
						if(wsin) sin <= in_sin;
						if(wcos) cos <= in_cos;
						if(wx0)	x0 <= in_x0;
						if(wy0)  y0 <= in_y0;
						if(we & ~yi[msb_xi_yi] & ~xi[msb_xi_yi])  image[yi][xi] <= 1;
			end
endmodule


