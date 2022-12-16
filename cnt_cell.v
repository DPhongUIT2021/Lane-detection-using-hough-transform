

module cnt_cell(clk, reset, D, D_not, Ci, Q, Ci_next);
			input clk, reset, D, D_not, Ci;
			output Q, Ci_next;
			
			reg Q;
			wire Q_next;
			
			assign Q_next = Q ^ Ci;
			assign Ci_next = (D_not & Q & Ci) | (D & ~Q & Ci);
			
			always @(posedge clk) begin
						if(reset) Q <= 1;
						else Q <= Q_next;
			end

endmodule
