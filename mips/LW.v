`include "F:/modelsim/mips/def.v"
module LW(op,addr,in_,out);
input [5:0] op;
input [31:0] in_;
input [1:0] addr;
//input wr;
output [31:0] out;
reg [31:0] out;
always@(*)
begin
	case(op)
		`op_lbu:
		begin
			  if(addr[1:0]==2'b0)
			  	out={24'b0,in_[7:0]};
			  else if(addr[1:0]==2'b1)
			  	out={24'b0,in_[15:8]};
			  else if(addr[1:0]==2'b10)
			  	out={24'b0,in_[23:16]};
			  else
			  	out={24'b0,in_[31:24]};
		end
		`op_lb:
		begin
			  if(addr[1:0]==2'b0)
			  	out={{24{in_[7]}},in_[7:0]};
			  else if(addr[1:0]==2'b1)
			  	out={{24{in_[15]}},in_[15:8]};
			  else if(addr[1:0]==2'b10)
			  	out={{24{in_[23]}},in_[23:16]};
			  else
			  	out={{24{in_[31]}},in_[31:24]};
		end
		`op_lhu:
		begin
			  if(addr[1]==1'b0)
			  	out={16'b0,in_[15:0]};
			  else
			  	out={16'b0,in_[31:16]};
		end
		`op_lh:
		begin
			  if(addr[1]==1'b0)
			  	out={{16{in_[15]}},in_[15:0]};
			  else
			  	out={{16{in_[31]}},in_[31:16]};
		end
		`op_lw: out=in_;
	endcase
end
endmodule
