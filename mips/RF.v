module RF(
			input [4:0] A1,
			input [4:0] A2,
			input [4:0] A3,
			input [31:0] WD,
			input RFWr,
			input Clk,
			output [31:0] RD1,
			output [31:0] RD2
);
			reg [31:0] RF[31:0];
			integer i;
			initial
			  begin
			    for(i=0;i<32;i=i+1)
			    RF[i]=0;
			  end
			always@(posedge Clk)
			begin
			   if(RFWr)
			   begin
			   RF[A3]<=WD;
			   end
			end
			assign RD1=RF[A1];
			assign RD2=RF[A2];
endmodule