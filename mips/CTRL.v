`include "F:/modelsim/mips/def.v"

module CTRL(op,funct,reset,Clk,zero,
PCWr,IRWr,RFWr,DMWr,NPCOp,ALUOp,EXTOp,GPRSel,WDSel,BSel
);
    input [5:0] op;
		input [5:0] funct;
		input reset;
		input Clk;
		input [6:0] zero;
		output PCWr;
		output IRWr;
		output RFWr;
		output DMWr;
		output [1:0] NPCOp;
		output [5:0] ALUOp;
		output [1:0] EXTOp;
		output [1:0] GPRSel;
		output [2:0] WDSel;
		output BSel;
		reg PCWr;
		reg IRWr;
		reg RFWr;
		reg DMWr;
		reg [1:0] NPCOp;
		reg [5:0] ALUOp;
		reg [1:0] EXTOp;
		reg [1:0] GPRSel;
		reg [2:0] WDSel;
		reg BSel;
   parameter Fetch  = 4'b0000,
             DCD    = 4'b0001,
             MA     = 4'b0010,
             MR     = 4'b0011,
             MemWB  = 4'b0100,
             MW     = 4'b0101,
             EXE    = 4'b0110,
             ALUWB  = 4'b0111,
             Branch = 4'b1000,
             Jump   = 4'b1001;
             
		wire r_type;
		wire i_type;
		wire branch_type;
		wire jump_type;
		wire lw_type;
		wire sw_type;
		wire mem_type;
		
		assign r_type=(op==`op_r);
		assign i_type=(op==`op_ori || op==`op_lui || op==`op_addiu  || op==`op_addi || op==`op_andi ||op==`op_xori ||op==`op_slti || op==`op_sltiu);
		assign branch_type=(op==`op_beq ||op==`op_bgez ||op==`op_bgtz ||op==`op_blez ||op==`op_bltz || op==`op_bne );
		assign jump_type=(op==`op_jal || op==`op_j);
		assign lw_type=(op==`op_lw || op==`op_lb || op==`op_lbu || op==`op_lh || op==`op_lhu);
		assign sw_type=(op==`op_sw || op==`op_sb || op==`op_sh);
		assign mem_type=lw_type||sw_type;
		
		reg[3:0] state,nextstate;
		always@(posedge Clk or posedge reset)
			begin
			if(reset)
			state<=Fetch;
			else
			state<=nextstate;
			end
		always@(*)
			begin
			  case(state)
			  Fetch: nextstate<=DCD;
			  DCD:
			      begin
			      if(mem_type)
			      nextstate=MA;
			      else if(r_type || i_type)
			      nextstate=EXE;
			      else if(branch_type)
			      nextstate=Branch;
			      else if(jump_type)
			      nextstate=Jump;
			      else
			      nextstate=Fetch;
			      end
			  MA: if(lw_type) 
			      nextstate<=MR;
			      else if(sw_type) 
			      nextstate<=MW; 
			  MR: nextstate=MemWB;
			  MW: nextstate=Fetch;
			  MemWB: nextstate=Fetch;
			  EXE: nextstate=ALUWB;
			  ALUWB: nextstate=Fetch;
			  Branch: nextstate=Fetch;
			  Jump: nextstate=Fetch;
			  default:nextstate=Fetch;
			  endcase
			end
			always@(*)
			begin
			  case(state)
			    Fetch:
				    begin
				      PCWr=1'b1;
							IRWr=1'b1;
							RFWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_order;
							ALUOp=`aluop_addu;
							EXTOp=`ext_signed;
							GPRSel=2'b0;
							WDSel=3'b0;
							BSel=1'b0;
				    end
				  DCD:
				   begin
				      PCWr=1'b0;
							IRWr=1'b0;
							RFWr=1'b0;
							DMWr=1'b0;
							case (op)
                   `op_r:       
                   begin
			               case (funct)
			                   `funct_addu: ALUOp = `aluop_addu;
			                   `funct_subu: ALUOp = `aluop_subu;
			                   `funct_add: ALUOp = `aluop_add;
			                   `funct_sub: ALUOp = `aluop_sub;
			                   `funct_and:  ALUOp = `aluop_and;
			                   `funct_or:   ALUOp = `aluop_or;
			                   `funct_xor:  ALUOp = `aluop_xor;
			                   `funct_nor:  ALUOp = `aluop_nor;
			                   `funct_sll:  ALUOp = `aluop_sll;       //逻辑左移
			                   `funct_sllv: ALUOp = `aluop_sllv;
			                   `funct_srl:  ALUOp = `aluop_srl;
			                   `funct_srlv: ALUOp = `aluop_srlv;
			                   `funct_sra:  ALUOp = `aluop_sra;
			                   `funct_srav: ALUOp = `aluop_srav;
			                   `funct_slt:  ALUOp = `aluop_slt;
			                   `funct_sltu: ALUOp = `aluop_sltu;
			                   `funct_jalr: ALUOp =0;
			                   `funct_jr:   ALUOp =0;
			                   `funct_mult: ALUOp = 0;
			                   `funct_multu: ALUOp = 0;
			                   `funct_div:  ALUOp = 0;
			                   `funct_divu:  ALUOp = 0;
			                   `funct_mfhi:  ALUOp = 0;
			                   `funct_mflo:  ALUOp = 0;
			                   `funct_mthi:  ALUOp = 0;
			                   `funct_mthi:  ALUOp = 0;
			                   default: ;
			               endcase
			               case(funct)
			                   `funct_mfhi: WDSel=3'b011;
			                   `funct_mflo: WDSel=3'b100;
			                   `funct_jalr: WDSel=3'b010;
			                  // `funct_jr:   WDSel=3'b010;
			                   default:     WDSel=3'b0;
			               endcase
			               EXTOp=`ext_signed;
			               BSel=1'b0;
			               GPRSel=2'b00;
			              end
                   `op_ori:     
			                   begin
				                   ALUOp = `aluop_or;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b0;
													 WDSel=3'b0;
													 BSel=1'b1;
													 NPCOp=`npc_order;
			                   end
			             `op_addiu:
						             begin
						             	 ALUOp = `aluop_addu;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b1;
													 WDSel=3'b0;
													 BSel=1'b1;
													 NPCOp=`npc_order;
						             end
						       `op_addi:
						             begin
						             	 ALUOp = `aluop_add;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b1;
													 WDSel=3'b0;
													 BSel=1'b1;
													 NPCOp=`npc_order;
						             end
			             `op_andi:
			                   begin
						             	 ALUOp = `aluop_and;
				                   EXTOp=`ext_zero;
													 GPRSel=2'b1;
													 WDSel=3'b0;
													 BSel=1'b1;
													 NPCOp=`npc_order;
			                   end
                   `op_lui:   //op_lui
                         begin
				                   ALUOp = `aluop_or;//op_lui
				                   EXTOp=`ext_highbit;
													 GPRSel=2'b1;
													 WDSel=3'b0;
													 BSel=1'b1;
													 NPCOp=`npc_order;
			                   end
			             `op_xori:
			                   begin
						             	 ALUOp = `aluop_xor;
				                   EXTOp=`ext_zero;
													 GPRSel=2'b1;
													 WDSel=3'b0;
													 BSel=1'b1;
													 NPCOp=`npc_order;
			                   end
			             `op_sw ||`op_sh ||`op_sb:
			                   begin
						             	 ALUOp = `aluop_addu;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b1;
													 WDSel=3'b1;
													 BSel=1'b1;
													 NPCOp=`npc_order;
			                   end
                   `op_beq||`op_bgez||`op_blez||`op_bgtz||`op_bltz||`op_bne:  
                         begin
				                   ALUOp = `aluop_subu;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b0;
													 WDSel=3'b0;
													 BSel=1'b0;
													 NPCOp=`npc_branch;
			                   end
                   `op_jal||`op_j:  
			                   begin
				                   ALUOp = `aluop_subu;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b10;
													 WDSel=3'b010;
													 BSel=1'b0;
													 NPCOp=`npc_jump;
			                   end
			             `op_slti:
			                  begin
				                   ALUOp = `aluop_slt;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b01;
													 WDSel=3'b0;  //表示wd输入为1
													 BSel=1'b1;
													 NPCOp=`npc_order;
			                  end
			              `op_sltiu:
			                  begin
				                   ALUOp = `aluop_sltu;
				                   EXTOp=`ext_signed;
													 GPRSel=2'b01;
													 WDSel=3'b0;  //表示wd输入为1
													 BSel=1'b1;
													 NPCOp=`npc_order;
			                  end
                   default: ;
              endcase
				    end
				  MA:
				   begin
				      PCWr=1'b0;
							IRWr=1'b0;
							RFWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_order;
							ALUOp=`aluop_addu;
							EXTOp=`ext_signed;
							GPRSel=2'b0;
							WDSel=3'b01;//`wdsel_dmout;
							BSel=1'b1;
				    end
				  MR:
				   begin
				      PCWr=1'b0;
							IRWr=1'b0;
							RFWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_order;
							ALUOp=`aluop_addu;
							EXTOp=`ext_signed;
							GPRSel=2'b0;
							WDSel=3'b01;
							BSel=1'b1;
				    end
				  MemWB:
				   begin
				      PCWr=1'b0;
							IRWr=1'b0;
							RFWr=1'b1;
							DMWr=1'b0;
							NPCOp=`npc_order;
							ALUOp=`aluop_addu;
							EXTOp=`ext_signed;
							GPRSel=`gprsel_rt;
							WDSel=3'b01;
							BSel=1'b1;
				    end
				  MW:
				   begin
				      PCWr=1'b0;
							IRWr=1'b0;
							RFWr=1'b0;
							DMWr=1'b1;
							NPCOp=`npc_order;
							ALUOp=`aluop_addu;
							EXTOp=`ext_signed;
							GPRSel=2'b0;
							WDSel=3'b1;
							BSel=1'b1;
				    end
				  EXE:
				   begin
				      PCWr=1'b0;
							IRWr=1'b0;
							RFWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_order;
							case (op)
							`op_r:
			              begin
			               case (funct)
			                   `funct_addu: ALUOp = `aluop_addu;
			                   `funct_subu: ALUOp = `aluop_subu;
			                   `funct_add: ALUOp = `aluop_add;
			                   `funct_sub: ALUOp = `aluop_sub;
			                   `funct_and:  ALUOp = `aluop_and;
			                   `funct_or:   ALUOp = `aluop_or;
			                   `funct_xor:  ALUOp = `aluop_xor;
			                   `funct_nor:  ALUOp = `aluop_nor;
			                   `funct_sll:  ALUOp = `aluop_sll;       //逻辑左移
			                   `funct_sllv: ALUOp = `aluop_sllv;
			                   `funct_srl:  ALUOp = `aluop_srl;
			                   `funct_srlv: ALUOp = `aluop_srlv;
			                   `funct_sra:  ALUOp = `aluop_sra;
			                   `funct_srav: ALUOp = `aluop_srav;
			                   `funct_slt:  ALUOp = `aluop_slt;
			                   `funct_sltu: ALUOp = `aluop_sltu;
			                   `funct_jalr: ALUOp =0;
			                   `funct_jr:   ALUOp =0;
			                   `funct_mult: ALUOp = 0;
			                   `funct_multu: ALUOp = 0;
			                   `funct_div:  ALUOp = 0;
			                   `funct_divu:  ALUOp = 0;
			                   `funct_mfhi:  ALUOp = 0;
			                   `funct_mflo:  ALUOp = 0;
			                   `funct_mthi:  ALUOp = 0;
			                   `funct_mthi:  ALUOp = 0;
			                   default: ;
			               endcase
			               case(funct)
			                   `funct_mfhi: WDSel=3'b011;
			                   `funct_mflo: WDSel=3'b100;
			                   `funct_jalr: WDSel=3'b010;
			                 //  `funct_jr:   WDSel=3'b010;
			                   default:     WDSel=3'b0;
			               endcase
			               
			               EXTOp=`ext_signed;
			               BSel=1'b0;
			               GPRSel=2'b00;
			              end
			               
              
							`op_ori:
							      begin
										ALUOp = `aluop_or;
			              EXTOp=`ext_zero;
			              BSel=1'b1;
			              GPRSel=2'b01;
			              WDSel=3'b00;
			              end
							`op_addiu:
										begin
										ALUOp=`aluop_addu;
										EXTOp=`ext_signed;
										BSel=1'b1;
										GPRSel=2'b01;
										WDSel=3'b00;
										end
						  `op_addi:
										begin
										ALUOp=`aluop_add;
										EXTOp=`ext_signed;
										BSel=1'b1;
										GPRSel=2'b01;
										WDSel=3'b00;
										end
							`op_andi:
	                   begin
				             	 ALUOp = `aluop_and;
		                   EXTOp=`ext_zero;
											 GPRSel=2'b1;
											 WDSel=3'b0;
											 BSel=1'b1;
	                   end
							`op_lui://`op_lui:
										begin
										ALUOp=`aluop_or;
										EXTOp=`ext_highbit;
										BSel=1'b1;
										GPRSel=2'b01;
										WDSel=3'b00;
										end
							`op_xori:
                   begin
			             	 ALUOp = `aluop_xor;
	                   EXTOp=`ext_zero;
										 GPRSel=2'b1;
										 WDSel=3'b0;
										 BSel=1'b1;
                   end
              `op_slti:
                   begin
			             	 ALUOp = `aluop_slt;
	                   EXTOp=`ext_signed;
										 GPRSel=2'b1;
										 WDSel=3'b0;
										 BSel=1'b1;
                   end
              `op_sltiu:
                   begin
			             	 ALUOp = `aluop_sltu;
	                   EXTOp=`ext_signed;
										 GPRSel=2'b1;
										 WDSel=3'b0;
										 BSel=1'b1;
                   end
				      endcase
				      end
				  ALUWB:
				   begin
				   	if(op==`op_r && (funct==`funct_jr ||funct==`funct_jalr))
				      PCWr=1'b1;
				    else
				    	PCWr=1'b0;
				    	
							IRWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_order;
					case (op)
							`op_r:
			              begin
			               case (funct)
			                   `funct_addu: ALUOp = `aluop_addu;
			                   `funct_subu: ALUOp = `aluop_subu;
			                   `funct_add: ALUOp = `aluop_add;
			                   `funct_sub: ALUOp = `aluop_sub;
			                   `funct_and:  ALUOp = `aluop_and;
			                   `funct_or:   ALUOp = `aluop_or;
			                   `funct_xor:  ALUOp = `aluop_xor;
			                   `funct_nor:  ALUOp = `aluop_nor;
			                   `funct_sll:  ALUOp = `aluop_sll;       //逻辑左移
			                   `funct_sllv: ALUOp = `aluop_sllv;
			                   `funct_srl:  ALUOp = `aluop_srl;
			                   `funct_srlv: ALUOp = `aluop_srlv;
			                   `funct_sra:  ALUOp = `aluop_sra;
			                   `funct_srav: ALUOp = `aluop_srav;
			                   `funct_slt:  ALUOp = `aluop_slt;
			                   `funct_sltu: ALUOp = `aluop_sltu;
			                   `funct_jalr: ALUOp =0;
			                   `funct_jr:   ALUOp =0;
			                   `funct_mult: ALUOp = 0;
			                   `funct_multu: ALUOp = 0;
			                   `funct_div:  ALUOp = 0;
			                   `funct_divu:  ALUOp = 0;
			                   `funct_mfhi:  ALUOp = 0;
			                   `funct_mflo:  ALUOp = 0;
			                   `funct_mthi:  ALUOp = 0;
			                   `funct_mthi:  ALUOp = 0;
			                   default: ;
			               endcase
			               case(funct)
			                   `funct_mfhi: WDSel=3'b011;
			                   `funct_mflo: WDSel=3'b100;
			                   `funct_jalr: WDSel=3'b010;
			                   `funct_jr:   WDSel=3'b010;
			                   default:     WDSel=3'b0;
			               endcase
			               case(funct)
			                   `funct_mult:  RFWr=1'b0;
			                   `funct_multu: RFWr=1'b0;
			                   `funct_div:   RFWr=1'b0;
			                   `funct_divu:  RFWr=1'b0;
			                   `funct_mthi:  RFWr=1'b0;
			                   `funct_mtlo:  RFWr=1'b0;
			                   `funct_jr:    RFWr=1'b0;
			                   default:   RFWr=1'b1;
			               endcase
			               EXTOp=`ext_signed;
			               BSel=1'b0;
			               GPRSel=2'b0;
			              end
              
							`op_ori:
							      begin
										ALUOp = `aluop_or;
			              EXTOp=`ext_zero;
			              BSel=1'b1;
			              GPRSel=2'b01;
			              WDSel=3'b00;
			              RFWr=1'b1;
			              end
							`op_addiu:
										begin
										ALUOp=`aluop_addu;
										EXTOp=`ext_signed;
										BSel=1'b1;
										GPRSel=2'b01;
										WDSel=3'b00;
										RFWr=1'b1;
										end
							`op_addi:
										begin
										ALUOp=`aluop_add;
										EXTOp=`ext_signed;
										BSel=1'b1;
										GPRSel=2'b01;
										WDSel=3'b00;
										RFWr=1'b1;
										end
							`op_andi:
	                   begin
				             	 ALUOp = `aluop_and;
		                   EXTOp=`ext_zero;
											 GPRSel=2'b1;
											 WDSel=3'b0;
											 BSel=1'b1;
											 RFWr=1'b1;
	                   end
							`op_lui://`op_lui:
										begin
										ALUOp=`aluop_or;
										EXTOp=`ext_highbit;
										BSel=1'b1;
										GPRSel=2'b01;
										WDSel=3'b00;
										RFWr=1'b1;
										end
							`op_xori:
                   begin
			             	 ALUOp = `aluop_xor;
	                   EXTOp=`ext_zero;
										 GPRSel=2'b1;
										 WDSel=3'b0;
										 BSel=1'b1;
										 RFWr=1'b1;
                   end
              `op_slti:
                   begin
			             	 ALUOp = `aluop_slt;
	                   EXTOp=`ext_signed;
										 GPRSel=2'b1;
										 WDSel=3'b0;
										 BSel=1'b1;
										 RFWr=1'b1;
                   end
              `op_sltiu:
                   begin
			             	 ALUOp = `aluop_sltu;
	                   EXTOp=`ext_signed;
										 GPRSel=2'b1;
										 WDSel=3'b0;
										 BSel=1'b1;
										 RFWr=1'b1;
                   end
							endcase
					 end
				  Branch:
				   begin
				   	case(op)
				   		`op_beq:
						   		if(zero[0]==1'b0)
		               PCWr=1'b1;
		              else
		              PCWr=1'b0;
				   		`op_bgez:
				   		begin
						   		if(zero[6]==1'b1) 
						   			begin
						   				if(zero[3]==1'b0)
				               PCWr=1'b1;
				              else
				               PCWr=1'b0;
		               end
		             else
		             	begin
			               if(zero[4]==1'b0) 
			                PCWr=1'b1;
			               else
			                PCWr=1'b0;
		              end
		          end
				   		`op_bgtz:
						   		if(zero[2]==1'b0) 
		               PCWr=1'b1;
		              else
		              PCWr=1'b0;
				   		`op_blez:
						   		if(zero[5]==1'b0) 
		               PCWr=1'b1;
		              else
		              PCWr=1'b0;
				   		`op_bne:
						   		if(zero[1]==1'b0) 
		               PCWr=1'b1;
		              else
		              PCWr=1'b0;
				    endcase
							IRWr=1'b0;
							RFWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_branch;
							ALUOp=`aluop_subu;
							EXTOp=`ext_signed;//无所谓
							GPRSel=0;
							WDSel=0;
							BSel=1'b0;
				    end
				  Jump:
				   begin
				   	if(op==`op_jal)
				   		begin
				   			RFWr=1'b1;
				   		end
				   	if(op==`op_j)
				   		begin
				   			RFWr=1'b0;
				   		end
				      PCWr=1'b1;
							IRWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_jump;
							ALUOp=0;
							EXTOp=`ext_signed;
							GPRSel=2'b10;//GPR[31]
							WDSel=3'b10;//`wdsel_pc;
							BSel=0;
				    end
				   default:
				   begin
				      PCWr=1'b0;
							IRWr<=1'b0;
							RFWr=1'b0;
							DMWr=1'b0;
							NPCOp=`npc_order;
							ALUOp=0;
							EXTOp=0;
							GPRSel=0;
							WDSel=0;
							BSel=0;
					 end
			endcase
			end
endmodule