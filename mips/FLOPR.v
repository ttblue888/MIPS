module FLOPR #(parameter WIDTH=8)(clk,rst,d,p);
		input clk;
		input rst;
		input [WIDTH-1:0] d;
		output [WIDTH-1:0] p;
		
		reg [WIDTH-1:0] p_r;          
    always@(posedge clk or posedge rst) 
    begin
      if (rst) 
         p_r<=0;
      else 
         p_r<=d;
    end
    assign p=p_r;   
endmodule