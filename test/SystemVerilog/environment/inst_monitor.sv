//`include "memory_if.sv"

class inst_minitor;

	//Virtual Interface
	virtual memory_if.monitor vif;

	//Attributes
	instruction_t instruction;
	data_t rs1, rs2, rd;
	data_t [11:0] imm;

    instruction_item_t inst_item;

	function new (virtual memory_if.monitor vif);
		this.vif = vif;
	endfunction


	task run();
        if(vif.rstn) begin
            $display("INST_MONITOR: Waiting reset");
            @(vif.rstn);
        end
		@(this.vif.addr);
		this.decode();
	endtask 

	protected function void decode();
        logic [6:0]  opcode = this.vif.rdata[6:0];
        logic [2:0]  funct3;
        logic [6:0]  funct7;

        case (opcode)
            `OP_R_TYPE : begin 
                this.rs1    = this.vif.rdata[19:15];
                this.rs2    = this.vif.rdata[24:20];
                this.rd     = this.vif.rdata[11:7 ];
                funct3 = this.vif.rdata[14:12];
                funct7 = this.vif.rdata[31:25];
                case (funct7)
                    `F7_TYPE0: begin
                        case (funct3)
                            `F3_TYPE0: begin
                                this.instruction = ADD;
                            end
                            `F3_TYPE1: begin
                                this.instruction = SLL;
                            end
                            `F3_TYPE2: begin
                                this.instruction = SLT;
                            end
                            `F3_TYPE3: begin
                                this.instruction = SLTU;
                            end
                            `F3_TYPE4: begin
                                this.instruction = XOR;
                            end
                            `F3_TYPE5: begin
                                this.instruction = SRL;
                            end
                            `F3_TYPE6: begin
                                this.instruction = OR;
                            end
                            `F3_TYPE7: begin
                                this.instruction = AND;
                            end
                            default : /* default */;
                        endcase
                    end
                    `F7_TYPE32: begin
                        case (funct3)
                            `F3_TYPE0: begin
                                this.instruction = SUB;
                            end
                            `F3_TYPE5: begin
                                this.instruction = SRA;
                            end
                            default : /* default */;
                        endcase
                    end
                    default : /* default */;
                endcase
            end
            `OP_I_TYPE : begin 
                this.rs1 = this.vif.rdata[19:15];
                this.imm = 32'(signed'(this.vif.rdata[31:20]));
                this.rd  = this.vif.rdata[11:7];
                funct3 = this.vif.rdata[14:12];
                funct7 = this.vif.rdata[31:25];
                case (funct3)
                    `F3_TYPE0: begin
                        this.instruction = ADDI;
                    end
                    `F3_TYPE1: begin
                        this.imm  = 32'(signed'(this.vif.rdata[24:20]));
                        this.instruction = SLLI;
                    end
                    `F3_TYPE2: begin
                        this.instruction = SLTI;
                    end
                    `F3_TYPE3: begin
                        this.instruction = SLTIU;
                    end
                    `F3_TYPE4: begin
                        this.instruction = XORI;
                    end
                    `F3_TYPE5: begin
                        this.imm  = 32'(signed'(this.vif.rdata[24:20]));
                        case (funct7)
                            `F7_TYPE0: this.instruction = SRLI;
                            `F7_TYPE0: this.instruction = SRAI;
                            default : /* default */;
                        endcase
                        
                    end
                    `F3_TYPE6: begin
                        this.instruction = ORI;
                    end
                    `F3_TYPE7: begin
                        this.instruction = ANDI;
                    end
                    default : /* default */;
                endcase
            end
            `OP_I_L_TYPE : begin 
                this.rs1 = this.vif.rdata[19:15];
                this.imm = 32'(signed'(this.vif.rdata[24:20]));
                this.rd  = this.vif.rdata[11:7];
                funct3   = this.vif.rdata[14:12];

                case (funct3)
                    `F3_TYPE0: begin
                        this.instruction = LB;
                    end
                    `F3_TYPE1: begin
                        this.instruction = LH;
                    end
                    `F3_TYPE2: begin
                        this.instruction = LW;
                    end
                    `F3_TYPE4: begin
                        this.instruction = LBU;
                    end
                    `F3_TYPE5: begin
                        this.instruction = LHU;
                    end
                    default : /* default */;
                endcase

            end
            `OP_S_TYPE : begin 
                this.rs1 = this.vif.rdata[19:15];
                this.rs2 = this.vif.rdata[24:20];
                this.imm = 32'(signed'({this.vif.rdata[31:25], this.vif.rdata[11:7 ]}));
                this.rd  = this.vif.rdata[11:7 ];
                funct3 = this.vif.rdata[14:12];

                case (funct3)
                    `F3_TYPE0: begin
                        this.instruction = SB;
                    end
                    `F3_TYPE1: begin
                        this.instruction = SH;
                    end
                    `F3_TYPE2: begin
                        this.instruction = SW;
                    end
                    default : /* default */;
                endcase

            end
            `OP_B_TYPE : begin 
                this.rs1    = this.vif.rdata[19:15];
                this.rs2    = this.vif.rdata[24:20];
                this.imm    = 32'(signed'({this.vif.rdata[31], this.vif.rdata[7], this.vif.rdata[30:25], this.vif.rdata[11:8]}));
                funct3 = this.vif.rdata[14:12];
                
                case (funct3)
                    `F3_TYPE0: begin
                        this.instruction = BEQ;
                    end
                    `F3_TYPE1: begin
                        this.instruction = BNE;
                    end
                    `F3_TYPE4: begin
                        this.instruction = BLT;
                    end
                    `F3_TYPE5: begin
                        this.instruction = BGE;
                    end
                    `F3_TYPE6: begin
                        this.instruction = BLTU;
                    end
                    `F3_TYPE7: begin
                        this.instruction = BGEU;
                    end
                    default : /* default */;
                endcase


            end
            `OP_JAL : begin 
                this.imm    = signed'({this.vif.rdata[31], this.vif.rdata[19:12], this.vif.rdata[20], this.vif.rdata[30:21]});
                this.instruction   = JAL;
            end
            `OP_JALR : begin 
                this.imm    = signed'(this.vif.rdata[31:12]);
                this.instruction   = JALR;
            end

            `OP_LUI : begin 
                this.imm    = this.vif.rdata[31:12];
                this.instruction   = LUI;
            end
            `OP_AUIPC : begin 
                this.imm    = this.vif.rdata[31:12];
                this.instruction   = AUIPC;
            end
            default : this.instruction = NO_INST;
        endcase

        $display("Intruction:%s \n RS1: %d RS2: %d RD: %d IMM: %d\n",
        this.instruction,
        this.rs1,
        this.rs2,
        this.rd,
        signed'(this.imm));

        this.inst_item.instruction = this.instruction;
        this.inst_item.rs1         = this.rs1;
        this.inst_item.rs2         = this.rs2;
        this.inst_item.rd          = this.rd;
        this.inst_item.imm         = this.imm;

    endfunction


endclass