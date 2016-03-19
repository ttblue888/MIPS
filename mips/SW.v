`include "F:/modelsim/mips/def.v"
module SW(op,in_,out8,out16,out32,wr);
input [5:0] op;
input [31:0] in_;
input wr;
output [7:0] out8;
reg [7:0] out8;
output [15:0] out16;
reg [15:0] out16;
output [31:0] out32;
reg [31:0] out32;
				always@(*)
				 begin
					if(wr==1'b1)
					case(op)
						`op_sb:
						begin
				      out8=in_[7:0];
						end
						`op_sh:
						begin
				      out16=in_[15:0];
						end
						`op_sw: out32=in_;
					endcase
				 end
endmodule
