`include "F:/modelsim/mips/def.v"
module ALU(A,B,aluop,C,zero,shamt,rt,exception);
    input [31:0] A;
		input [31:0] B;
		input [4:0] aluop;
		input [4:0] shamt;
		input [4:0] rt;
		output [31:0] C;
		output [2:0] zero;
		output exception;
		reg [31:0] C;
		reg exception;
		reg [6:0] zero;
		integer i;
		reg [32:0] t;
		always@(A or B or aluop)
				begin
					begin
						if(A==B)   //beq
							zero[0]=1'b0;
						else
							zero[0]=1'b1;
						if(A!=B)   //bne
							zero[1]=1'b0;
						else
							zero[1]=1'b1;
				  	if(A[31]==1'b0 && A!=0)     //A>0,bgtz
				  		zero[2]=1'b0;
						else
							zero[2]=1'b1;
				    if(A[31]==1'b0)            //A>=0,bgez
				    	begin
				  		zero[3]=1'b0;
				  		zero[4]=1'b1;           //A<0,bltz
				  	  end
						else
							begin
							zero[3]=1'b1;
							zero[4]=1'b0;
						  end
					  if(rt==5'b00001)
					  	zero[6]=1'b1;
					  if(rt==5'b00000)
					  	zero[6]=1'b0;
				    if(A[31]==1'b1 || A==0)    //A<=0,blez
				  		zero[5]=1'b0;
						else
							zero[5]=1'b1;
					end
				  case(aluop)
				  `aluop_addu: C=A+B;
				  `aluop_add:
						  begin
						  	t={{A[31]},A[31:0]}+{{B[31]},B[31:0]};
						  	if(t[31]==t[32])
						  		exception=1'b0;
						  	else
						  		exception=1'b1;
						  	C=t[31:0];
						  end
				  `aluop_subu: C=A-B;
				  `aluop_sub:
						  begin
						  	t={{A[31]},A[31:0]}-{{B[31]},B[31:0]};
						  	if(t[31]==t[32])
						  		exception=1'b0;
						  	else
						  		exception=1'b1;
						  	C=t[31:0];
						  end
				  `aluop_or:   C=A|B;
				  `aluop_xor:  C=A^B;
				  `aluop_and:  C=A&B;
			    `aluop_nor:  C=~(A|B);              //���
					`aluop_sllv:  C=B<<(A[4:0]);        //�߼��ɱ�����
					`aluop_sll:   C=B<<shamt[4:0];      //�߼�����
					`aluop_srlv:  C=B>>(A[4:0]);        //�߼��ɱ�����
		      `aluop_srl:   C=B>>shamt[4:0];      //�߼�����
		      `aluop_sra:                         //��������
				      begin
				      for(i=1; i<=shamt[4:0]; i=i+1)
					     C[32-i] = B[31];
					    for(i=31-shamt[4:0]; i>=0; i=i-1)
					     C[i] = B[i+shamt[4:0]];
		          end        
		      `aluop_srav:                        //�����ɱ�����
				      begin
				      for(i=1; i<=A[4:0]; i=i+1)
					     C[32-i] = B[31];
					    for(i=31-A[4:0]; i>=0; i=i-1)
					     C[i] = B[i+A[4:0]];
		          end  
		      `aluop_slt:                         //С����һ
				      begin
				        C=32'b0;
				        if(A[31]==1'b0 && B[31]==1'b0 && A<B) C=32'b1;
				        if(A[31]==1'b1 && B[31]==1'b0 ) C=32'b1;
				        if(A[31]==1'b1 && B[31]==1'b1 && A>B) C=32'b1;
				      end
				  `aluop_sltu:                        //С����һ
				      begin
				      	if(({1'b0,A})<({1'b0,B})) C=32'b1;
				      	else    C=32'b0;
				      end
				  default:          ;
				  endcase
				end
				
		
endmodule