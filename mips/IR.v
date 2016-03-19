module IR(clk,reset,irwr,im_inst,ir_inst);
   input clk;
   input reset;
   input irwr;
   input [31:0] im_inst;
   output [31:0] ir_inst;
   reg [31:0] ir_inst;
   always@(posedge clk or posedge reset)
   begin
      if(reset)
        ir_inst<=32'b0;
      else if(irwr)
        ir_inst<=im_inst;
   end
endmodule