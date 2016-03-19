module PC(
input wire[31:0] NPC,
input wire Clk,
input wire RST,
input wire PCWr,
output reg[31:0] PC
);
always@(posedge Clk or posedge RST)
begin
    if(RST)
      PC=32'h0000_0000;
    else if(PCWr)
      PC<=NPC;
    else
      PC<=PC;
end
endmodule