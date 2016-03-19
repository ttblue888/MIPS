`include "def.v"
module EXT(imm16,extop,imm32);
input [15:0] imm16;
input [1:0] extop;
output [31:0] imm32;
reg [31:0] imm32;
always@(*)
begin
  case(extop)
  `ext_zero:    imm32<={16'h0000,imm16};
  `ext_signed:  imm32<={{16{imm16[15]}},imm16};
  `ext_highbit: imm32<={imm16,16'h0000};
  default: ;
  endcase
end
endmodule