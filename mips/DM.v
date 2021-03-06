`include "F:/modelsim/mips/def.v"
module DM(
			input [11:0] addr,
			input [31:0] in32,
			input [15:0] in16,
			input [7:0]  in8,
			input [5:0] op,
			input DMWr,
			input Clk,
			output [31:0] DO
);
			reg [31:0] mem[1023:0];
			always@(posedge Clk)
			begin
			  if(DMWr)
			  	begin
			  		case(op)
								`op_sb:
								begin
									  if(addr[1:0]==2'b0)
									  	mem[addr[11:2]][7:0]=in8;
									  else if(addr[1:0]==2'b1)
									  	mem[addr[11:2]][15:8]=in8;
									  else if(addr[1:0]==2'b10)
									  	mem[addr[11:2]][23:16]=in8;
									  else
									  	mem[addr[11:2]][31:24]=in8;
								end
								`op_sh:
								begin
									  if(addr[1]==1'b0)
									  	begin
									  	mem[addr[11:2]][15:0]=in16;
									    end
									  else if(addr[1]==1'b1)
									  	begin
									  	mem[addr[11:2]][31:16]=in16;
									    end
								end
								`op_sw: mem[addr[11:2]]=in32;
						endcase
					end
			end
			assign DO=mem[addr[11:2]];
endmodule