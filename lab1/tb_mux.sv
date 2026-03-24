`timescale 1ns/1ps

module tb_mux;
   logic [31:0] t_i1 = 32'd256;
   logic [31:0] t_i2 = 32'd512;
   logic [31:0] t_i3 = 32'd1000000;
   logic [31:0] t_i4 = 32'd400012300;
   logic [31:0] muxOut;
   logic [2:0] sel;

   mux dut(.f(muxOut), .i1(t_i1), .i2(t_i2), .i3(t_i3), .i4(t_i4), .sel(sel));

   initial begin
     $monitor($time," t1 = %d | t2 = %d | t3 = %d | t4 = %d | sel = %d | muxOut = %d", t_i1, t_i2, t_i3, t_i4, sel, muxOut);
     for(sel = 0; sel < 3'd4; sel++) #10;     
     $stop;
   end

endmodule: tb_mux
