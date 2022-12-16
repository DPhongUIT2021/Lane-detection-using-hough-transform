


module shift_right(clk, reset, S, IR, out, sel_out);
			parameter msb = 7, msb_sel_out = 2;
			input clk, S, IR, reset;
			input[msb_sel_out:0] sel_out;
			output out;
			
			reg[msb:0] Q;
			reg out;
			wire[msb:0] out_mux_in, I1, I0;
			
			assign out_mux_in[msb:0] = (S == 1) ? I1[msb:0] : I0[msb:0];
			assign I1[msb:0] = {IR, Q[msb:1]};
			assign I0[msb:0] = Q[msb:0];
			
			always @(sel_out, Q) begin
					case(sel_out)
							3'd0: out = Q[7];
							3'd1: out = Q[6];
							3'd2: out = Q[5];
							3'd3: out = Q[4];
							3'd4: out = Q[3];
							3'd5: out = Q[2];
							3'd6: out = Q[1];
							3'd7: out = Q[0];
							default out = 1'bz;
					endcase
			end

			always @(posedge clk) begin
					if(reset) Q[msb:0] <= {msb+1{1'bz}};
					else Q[msb:0] <= out_mux_in[msb:0];
			end


endmodule


