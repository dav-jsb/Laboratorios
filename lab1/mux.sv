module mux
(
output logic [31:0] f,
input logic [31:0] i1, i2, i3, i4,
input logic [1:0] sel
); 

  always_comb begin
     case (sel)
	2'd0: f = i1;
	2'd1: f = i2;
	2'd2: f = i3;
	2'd3: f = i4;
	default: f = 32'd0;
     endcase
  end

endmodule: mux

