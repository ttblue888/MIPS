module IM(addr,do);
input [11:2] addr;
output [31:0] do;
reg [31:0] mem[1023:0];
    assign do=mem[addr];
endmodule