

module block_pre(clk, reset_pre, reset_post, x, y, ctrl_pre, ctrl_post, phi_degree, r_pre, M_phi, r_int, M_r, j_inc, j, eq_179, xi, yi, j_gt_1000);
		parameter msb_ctrl_pre = 29, msb_ctrl_post = 10
		,msb = 15, K = 16'h4DBA, cvt_degree = 16'hE52E, pi = 24'hC90FDA, cvt_radian = 16'h0477, msb_xi_yi = 11
		, phi_init = 16'h0000, denta_phi = 24'h011DF4, msb_R1 = 23, msb_phi = 7, msb_r = 11, msb_j = 11
		, msb_ctrl_bus = 22, msb_ctrl_reg_func = 6, msb_adder = 23;

		input[msb:0] x, y;
		input clk;
		input[msb_ctrl_pre:0] ctrl_pre;
		input[msb_phi:0] M_phi;
		input[msb_r:0] r_int, M_r;
		input[msb_ctrl_post:0] ctrl_post;
		input[msb_j:0] j_inc;
		input reset_post, reset_pre, eq_179;

		output[msb:0] phi_degree;
		output[msb:0] r_pre;
		output[msb_j:0] j;
		output[msb_xi_yi:0] xi, yi;
		output j_gt_1000;

		reg[msb:0] R2, R3;
		reg[msb_R1:0] R1;

		wire[msb:0] in_mul_A, in_mul_B, in_sin_cos, out_sin, out_cos;
		wire[msb:0] cos_post, sin_post, x0, y0;
		wire[msb_R1:0] in_add_A, in_add_B, out_add, in_gt90;
		wire[msb:0] in_R2, in_R3;
		wire[msb_R1:0] in_R1;
		wire[31:0] out_mul_32;
		wire[msb:0] out_mul_shift_15;
		wire gt_90, gt_90_post;
		wire wR1, wR2, wR3, ctrl_adder_actual;
		wire[2:0] ctrl_adder;
		wire[23:0] phi_post;
		wire[msb_adder:0] denta_xy_post;
		wire sign_j, eq_pi;
		wire[msb_j-1:0] j_real;


		wire[1:0] s_R1;
		wire[6:0] mulA;
		wire[6:0] mulB;
		wire[4:0] addA;
		wire[3:0] addB;
		wire[msb_ctrl_bus:0] ctrl_bus;
		wire[msb_ctrl_reg_func:0] ctrl_reg_func;
		wire smux_gt90;


		mul16_vedic     mul_vedic(.A(in_mul_A), .B(in_mul_B), .O(out_mul_32));
		adder24_sub_add add(.A(in_add_A), .B(in_add_B), .O(out_add), .ctrl_adder(ctrl_adder_actual));
		sin_cos		    cordic(.in_z0(in_sin_cos), .out_sin(out_sin), .out_cos(out_cos));
		eq_pi			equal_pi(.phi(out_add), .eq_pi(eq_pi) );
		gt_90		       greater_90(.z(in_gt90), .gt(gt_90));
		block_post      bk_post(.clk(clk), .reset(reset_post), .ctrl(ctrl_post), .mul(out_mul_32)
							, .add_pre(out_add), .j_inc(j_inc), .gt_90(gt_90), .cos(cos_post), .sin(sin_post)
							, .x0(x0), .y0(y0), .j_out(j), .gt_90_post(gt_90_post), .R2(R2), .R3(R3), .j_gt_1000(j_gt_1000), .xi(xi), .yi(yi));

		assign in_R1 = (~gt_90 & smux_gt90) ? phi_post : out_add;
		assign in_R2 = out_mul_shift_15; 														// : {msb+1{1'bz}}
		assign in_R3 = out_mul_shift_15;
		assign in_sin_cos[msb:0] = (gt_90) ? out_add[msb_R1:8] : R1[msb_R1:8];
		assign phi_degree[msb:0] = out_mul_32[31:16];
		assign r_pre[msb:0] = out_mul_shift_15[msb:0];
		assign in_gt90 = (smux_gt90) ? phi_post : R1;
		assign ctrl_adder_actual = ((ctrl_adder[2] & gt_90) | (ctrl_adder[1] & sign_j) | (ctrl_adder[0] & ((~gt_90_post & ~sign_j) | (gt_90_post & sign_j))));
		assign sign_j = j[msb_j];
		assign j_real[msb_j-1:0] = j[msb_j-1:0];

		assign out_mul_shift_15[msb:0] = out_mul_32[30:15];
		assign phi_post[msb_R1:0] = out_mul_32[msb_R1+2:2];
		assign denta_xy_post = {sign_j, out_mul_32[25:3]}; // Q12,12

		assign in_mul_A = (mulA[6]) ? x : (mulA[5]) ? y : (mulA[4]) ? K : (mulA[3]) ? R1[msb_R1:8] : (mulA[2]) ? {M_phi, {8{1'b0}}}
								: (mulA[1]) ? {M_r, {4{1'b0}}} : (mulA[0]) ? {{msb-(msb_j-1){1'b0}}, j_real} : {msb+1{1'bz}};
		assign in_mul_B = (mulB[6]) ? cvt_degree : (mulB[5]) ? out_add[msb:0] : (mulB[4]) ? out_sin : (mulB[3]) ? out_cos
								: (mulB[2]) ? cvt_radian : (mulB[1]) ? cos_post : (mulB[0]) ? sin_post : {msb+1{1'bz}};

		assign in_add_A = (addA[4]) ? pi : (addA[3]) ? {{8{1'b0}}, R3} : (addA[2]) ? denta_phi : (addA[1]) ? {x0, {8{1'b0}}}
								: (addA[0]) ? {y0, {8{1'b0}}} : {msb_R1+1{1'bz}};
		assign in_add_B = (addB[3]) ? R1 : (addB[2]) ? {{8{1'b0}}, R2} : (addB[1]) ? phi_post : (addB[0]) ? {1'b0, denta_xy_post[msb_adder-1:0]} : {msb_adder+1{1'bz}};

		assign {mulA[6:0], mulB[6:0], addA[4:0], addB[3:0]} = ctrl_bus[msb_ctrl_bus:0];
		assign {wR1, wR2, wR3, ctrl_adder[2:0], smux_gt90} = ctrl_reg_func[msb_ctrl_reg_func:0];
		assign {ctrl_bus[msb_ctrl_bus:0], ctrl_reg_func[msb_ctrl_reg_func:0]} = ctrl_pre[msb_ctrl_pre:0];


		always @(posedge clk) begin
				if(reset_pre | eq_pi)	R1 <= phi_init;
				else begin
					if(wR1) R1 <= in_R1;
					if(wR2) R2 <= in_R2;
					if(wR3) R3 <= in_R3;
				end
		end
		
		
		
		

endmodule

