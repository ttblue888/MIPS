`include "F:/modelsim/mips/def.v"
module mem_sel(op,addr,in_,out,wr);
input [5:0] op;
input [31:0] in_;
input [1:0] addr;
input wr;
output [31:0] out;
reg [31:0] out;
always@(*)
begin
	if(wr==1'b1)
	case(op)
		`op_sb:
		begin
			  if(addr[1:0]==2'b0)
			  	out[7:0]=in_[7:0];
			  else if(addr[1:0]==2'b1)
			  	out[15:8]=in_[7:0];
			  else if(addr[1:0]==2'b10)
			  	out[23:16]=in_[7:0];
			  else
			  	out[31:24]=in_[7:0];
		end
		`op_sh:
		begin
			  if(addr[1]==1'b0)
			  	begin
			  	out[15:0]=in_[15:0];
			    end
			  else if(addr[1]==1'b1)
			  	begin
			  	out[31:16]=in_[15:0];
			    end
		end
		`op_sw: out=in_;
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
