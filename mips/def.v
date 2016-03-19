//aluop
`define aluop_addu 5'b00000
`define aluop_add  5'b00001    
`define aluop_subu 5'b00010
`define aluop_sub  5'b00011
`define aluop_nor  5'b00100
`define aluop_or   5'b00101
`define aluop_xor  5'b00110
`define aluop_sllv  5'b00111
`define aluop_srl  5'b01000
`define aluop_and  5'b01001
`define aluop_mult 5'b01010
`define aluop_multu 5'b01011
`define aluop_div  5'b01100
`define aluop_divu 5'b01101
`define aluop_sra  5'b01110
`define aluop_srav 5'b01111
`define aluop_mfhi 5'b10000
`define aluop_mflo 5'b10001
`define aluop_mthi 5'b10010
`define aluop_mtlo 5'b10011
`define aluop_sll  5'b10100
`define aluop_srlv 5'b10101
`define aluop_slt  5'b10110
`define aluop_sltu 5'b10111


`define zero_bgez 1'b1    //�ж����Ǵ��ڵ�����ת����С����ת
`define zero_bltz 1'b0
//extop
`define ext_zero    2'b00
`define ext_signed  2'b01
`define ext_highbit 2'b10

//npcop
`define npc_order  2'b00
`define npc_branch 2'b01
`define npc_jump   2'b10

//GPRSel
`define gprsel_rd   2'b00
`define gprsel_rt   2'b01
`define gprsel_31   2'b10

//WDSel
`define wdsel_aluout 3'b000
`define wdsel_dmout  3'b001
`define wdsel_pc     3'b010
`define wdsel_hi     3'b011
`define wdsel_lo     3'b100


//ctr_op
`define op_r       6'b000000
`define op_beq     6'b000100
`define op_jal     6'b000011   //��ת������
`define op_j       6'b000010   //��ת
`define op_bgez    6'b000001  //���ڵ���0ʱת��
`define op_bgtz    6'b000111   //����0ʱת��
`define op_blez    6'b000110   //С�ڵ���0ʱת��
`define op_bltz    6'b110001   //С��0ʱת��
`define op_bne     6'b000101   //������ʱ��ת
`define op_addiu   6'b001001
`define op_addi    6'b001000   //
`define op_ori     6'b001101
`define op_slti    6'b001010   //С����������һ���з��ţ�
`define op_sltiu   6'b001011   //С����������һ���޷��ţ�
`define op_andi    6'b001100
`define op_xori    6'b001110
`define op_eret    6'b010000   //δ��
`define op_mfc0    6'b010000   //δ��
`define op_mtc0    6'b010000   //δ��
`define op_lw      6'b100011
`define op_lb      6'b100000
`define op_lbu     6'b100100
`define op_lh      6'b100001
`define op_lhu     6'b100101
`define op_lui     6'b001111
`define op_sw      6'b101011
`define op_sh      6'b101001
`define op_sb      6'b101000




//ctr_funct
`define funct_addu   6'b100001
`define funct_subu   6'b100011
`define funct_sub    6'b100010             //
`define funct_add    6'b100000             //
`define funct_and    6'b100100
`define funct_or     6'b100101
`define funct_xor    6'b100110
`define funct_nor    6'b100111
`define funct_mult   6'b011000
`define funct_multu  6'b011001
`define funct_div    6'b011010
`define funct_divu   6'b011011
`define funct_sll    6'b000000             //
`define funct_sllv   6'b000100
`define funct_srl    6'b000010             //
`define funct_srlv   6'b000110
`define funct_sra    6'b000011   //�������� ?
`define funct_srav   6'b000111   //�����ɱ�����
`define funct_mfhi   6'b010000   //��hi�Ĵ���
`define funct_mthi   6'b010001   //дhi�Ĵ���
`define funct_mflo   6'b010010   //��lo�Ĵ���
`define funct_mtlo   6'b010011   //дlo�Ĵ���
`define funct_slt    6'b101010   //С����һ(�з���)
`define funct_sltu   6'b101011   //С����һ���޷��ţ�
`define funct_jalr   6'b001001   //��ת������
`define funct_jr     6'b001000   //��ת���Ĵ���
`define funct_syscall 6'b001100  //ϵͳ����
`define funct_break  6'b001101   //�ϵ�
