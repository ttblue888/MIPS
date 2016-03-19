`include "F:/modelsim/mips/def.v"
module NPC(PC,npc_op,imm,NPC);
input [31:2] PC;
input [1:0] npc_op;
input [25:0] imm;
output [31:0] NPC;
reg [31:0] NPC;
always@(*)
begin
  case(npc_op)
  `npc_order: NPC={PC+1,2'b00};
  `npc_branch: NPC={PC,2'b00} + {{{14{imm[15]}}, imm[15:0]},2'b00};
  `npc_jump: NPC={PC[31:28],imm[25:0],2'b00};
  default:;
  endcase
end
endmodule