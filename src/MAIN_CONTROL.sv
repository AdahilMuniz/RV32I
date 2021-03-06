module MAIN_CONTROL(
    output logic [1:0] o_Ctrl_Jump,
    output logic       o_MemRead,
    output logic       o_MemWrite,
    output logic [1:0] o_RegSrc,
    output logic [2:0] o_ALUOp,
    output logic       o_ALUSrc1,
    output logic       o_ALUSrc2,
    output logic       o_RegWrite,
    output logic       o_CSR_en,
    input  logic [6:0] i_OPCode
    );

    always @(*) begin

        case(i_OPCode)
            `OP_R_TYPE : begin
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b00;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b0;
                o_RegWrite = 1'b1;
                o_ALUOp    = 3'b010;
                o_CSR_en   = 1'b0;
            end

            `OP_I_TYPE : begin
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b00;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b1;
                o_RegWrite = 1'b1;
                o_ALUOp    = 3'b011;
                o_CSR_en   = 1'b0;
            end

            `OP_I_L_TYPE : begin
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b1;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b01;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b1;
                o_RegWrite = 1'b1;
                o_ALUOp    = 3'b000;
                o_CSR_en   = 1'b0;
            end

            `OP_S_TYPE : begin
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b1;
                o_RegSrc   = 2'b00;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b1;
                o_RegWrite = 1'b0; 
                o_ALUOp    = 3'b000;
                o_CSR_en   = 1'b0;
            end

            `OP_B_TYPE : begin
                o_Ctrl_Jump= 2'b01;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b00;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b0;
                o_RegWrite = 1'b0; 
                o_ALUOp    = 3'b001;
                o_CSR_en   = 1'b0;
            end

            `OP_LUI : begin
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b00;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b1;
                o_RegWrite = 1'b1; 
                o_ALUOp    = 3'b100;
                o_CSR_en   = 1'b0;
            end

            `OP_AUIPC : begin
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b00;
                o_ALUSrc1  = 1'b1;
                o_ALUSrc2  = 1'b1;
                o_RegWrite = 1'b1; 
                o_ALUOp    = 3'b101;
                o_CSR_en   = 1'b0;
            end

            `OP_JAL : begin
                o_Ctrl_Jump= 2'b10;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b10;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b0;
                o_RegWrite = 1'b1; 
                o_ALUOp    = 3'b000;
                o_CSR_en   = 1'b0;
            end

            `OP_JALR : begin
                o_Ctrl_Jump= 2'b11;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b10;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b1;
                o_RegWrite = 1'b1; 
                o_ALUOp    = 3'b011;
                o_CSR_en   = 1'b0;
            end

            `OP_SYSTEM : begin 
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b11;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b0;
                o_RegWrite = 1'b1; 
                o_ALUOp    = 3'b000;
                o_CSR_en   = 1'b1;
            end

            default : begin
                o_Ctrl_Jump= 2'b00;
                o_MemRead  = 1'b0;
                o_MemWrite = 1'b0;
                o_RegSrc   = 2'b00;
                o_ALUSrc1  = 1'b0;
                o_ALUSrc2  = 1'b0;
                o_RegWrite = 1'b0; 
                o_ALUOp    = 3'b0;
                o_CSR_en   = 1'b0;
            end

        endcase
    end

endmodule
