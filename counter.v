
module counter(clk, reset, up_down, en, out);
		parameter msb = 2;
		input clk, reset, en, up_down;
		output[msb:0] out;
		
		wire[msb-1:0] Ci, Ci_next;
		wire ov, D_not, D;
		
		cnt_cell cnt[2:0](.clk(clk), .reset(reset), .D(D), .D_not(D_not), .Ci({Ci_next, en}), .Q(out), .Ci_next({ov, Ci_next}));
		
		assign D_not = ~up_down;
		assign D = up_down;
		
endmodule
