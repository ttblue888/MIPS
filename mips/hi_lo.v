`include "F:/modelsim/mips/def.v"
module hi_lo(A,B,hi,lo,funct);
		input [31:0] A;
		input [31:0] B;
		input [5:0] funct;
		output [31:0] hi;
		output [31:0] lo;
		reg [31:0] hi;
		reg [31:0] lo;
		always@(A or B or funct)
		begin
		   case(funct) 
		   `funct_mult:    {hi,lo}=A*B;
		   `funct_multu:   {hi,lo}=({1'b0,A})*({1'b0,B});
		   `funct_div:    
										   begin
										     lo=A/B;
										     hi=A%B;
										   end
		    `funct_divu:
										   begin
										     lo=({1'b0,A})/({1'b0,B});
										     hi=({1'b0,A})%({1'b0,B});
										   end
			  `funct_mthi:   hi=A;  //Ð´¼Ä´æÆ÷
			  `funct_mtlo:   lo=A;  //Ð´¼Ä´æÆ÷
			  default:     
			  begin
			  	hi=hi;
			  	lo=lo;
			  end
			  endcase      
		end
endmodule
