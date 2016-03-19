`include "F:/modelsim/mips/def.v"
module MIPS(
   input clk,
   input rst
);
   wire pcwr;
   wire irwr;
   wire dmwr;
   wire rfwr;
   wire [1:0] extop;
   wire [4:0] aluop;
   wire [1:0] npcop;
   wire [1:0] gprsel;
   wire [2:0] wdsel;
   wire [1:0] bsel;
   wire [6:0] zero;
   wire [31:0] pc;
   wire [31:2] rpc;
   wire [31:0] npc;
   wire [31:0] inst,im_inst;
   wire [5:0] op;
   wire [5:0] funct;
   wire [4:0] rs;
   wire [4:0] rt;
   wire [4:0] rd;
   wire [4:0] shamt;
   wire [4:0] A3;
   wire [15:0] imm16;
   wire [31:0] imm32;
   wire [25:0] imm;
   wire [31:0] d1,rd1,d2,rd2,rd3,B;
   wire [15:0] rd4;  //sh的选择
   wire [7:0]  rd5;  //sb的选择
   wire [31:0] aluout,raluout;
   wire [31:0] wd;
   wire [31:0] dm_out,dm_out1,rdm_out;
   wire [31:0] hi,lo,rhi,rlo;
   
   assign op=inst[31:26];
   assign funct=inst[5:0];
   assign rs=inst[25:21];
   assign rt=inst[20:16];
   assign rd=inst[15:11];
   assign shamt=inst[10:6];
   assign imm16=inst[15:0];
   assign imm=inst[25:0];
   assign pc[1:0]=2'b0;
   
   PC    jy_pc(.NPC(npc),.Clk(clk),.RST(rst),.PCWr(pcwr),.PC(pc));
  PC_Sel jy_pc_sel(.op(op),.funct(funct),.PC_(pc[31:2]),.GPRA(rd1),.PC(rpc));
   IM    jy_im(.addr(pc[31:2]),.do(im_inst));
   IR    jy_ir(.clk(clk),.irwr(irwr),.reset(rst),.im_inst(im_inst),.ir_inst(inst));
   RF    jy_rf(.A1(rs),.A2(rt),.A3(A3),.WD(wd),.RFWr(rfwr),.Clk(clk),.RD1(d1),.RD2(d2));
   ALU   jy_alu(.A(rd1),.B(B),.aluop(aluop),.C(aluout),.zero(zero),.shamt(shamt),.rt(rt));
   hi_lo jy_hi_lo(.A(rd1),.B(B),.hi(hi),.lo(lo),.funct(funct));
   EXT   jy_ext(.imm16(imm16),.extop(extop),.imm32(imm32));
   DM    jy_dm(.op(op),.addr(raluout[11:0]),.in8(rd5),.in16(rd4),.in32(rd3),.DMWr(dmwr),.Clk(clk),.DO(dm_out));
   SW    jy_sw(.op(op),.in_(rd2),.out8(rd5),.out16(rd4),.out32(rd3),.wr(dmwr));
   LW    jy_lw(.op(op),.addr(raluout[1:0]),.in_(dm_out),.out(dm_out1));
   NPC   jy_npc(.PC(rpc),.npc_op(npcop),.imm(imm),.NPC(npc));
   mux4 #(5)  jy_mux4_gpr_sel(.d0(rd),.d1(rt),.d2(5'b11111),.d3(5'b0),.s(gprsel),.y(A3));
   mux8 #(32) jy_mux8_gpr_data(.d0(raluout),.d1(rdm_out),.d2(pc+4),.d3(rhi),.d4(rlo),.d5(32'b0),.d6(32'b0),.d7(32'b0),.s(wdsel),.y(wd));
   mux2 #(32) jy_mux2_B_sel(.d0(rd2),.d1(imm32),.s(bsel),.y(B));
   CTRL  jy_ctrl(.op(op),.funct(funct),.reset(rst),.Clk(clk),.zero(zero),
                 .PCWr(pcwr),.IRWr(irwr),.RFWr(rfwr),.DMWr(dmwr),.NPCOp(npcop),
                 .ALUOp(aluop),.EXTOp(extop),.GPRSel(gprsel),.WDSel(wdsel),.BSel(bsel));
   FLOPR #(32) jy_A(.clk(clk),.rst(rst),.d(d1),.p(rd1));
   FLOPR #(32) jy_B(.clk(clk),.rst(rst),.d(d2),.p(rd2));
   FLOPR #(32) jy_C(.clk(clk),.rst(rst),.d(aluout),.p(raluout));
   FLOPR #(32) jy_hi(.clk(clk),.rst(rst),.d(hi),.p(rhi));
   FLOPR #(32) jy_lo(.clk(clk),.rst(rst),.d(lo),.p(rlo));
   FLOPR #(32) jy_DR(.clk(clk),.rst(rst),.d(dm_out1),.p(rdm_out));
endmodule
   