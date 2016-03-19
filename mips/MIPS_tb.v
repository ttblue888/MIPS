module MIPS_tb;
		reg clk,rst;
		MIPS   jy_mips(.clk(clk),.rst(rst));
		initial begin
      $readmemh("code.txt",jy_mips.jy_im.mem);
      $readmemh("data.txt",jy_mips.jy_dm.mem);
      
      clk=1;
      rst=0;
      #5;
      rst=1 ;
      #20;
      rst=0 ;
   end
   always
	   #(50) clk=~clk;
endmodule