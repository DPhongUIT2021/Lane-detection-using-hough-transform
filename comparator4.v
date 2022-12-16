

module comparator4(a, b, gt, lt);
		parameter msb = 3;
		input[msb:0] a, b;
		output gt, lt;
		
		wire gt0, lt0, gt1, lt1;
		
		comparator2 c0(.a(a[msb:msb/2+1]), .b(b[msb:msb/2+1]), .gt(gt0), .lt(lt0));
		comparator2 c1(.a(a[msb/2:0]), .b(b[msb/2:0]), .gt(gt1), .lt(lt1));
		comparator2 c2(.a({gt0, gt1}), .b({lt0, lt1}), .gt(gt), .lt(lt));
		
endmodule

