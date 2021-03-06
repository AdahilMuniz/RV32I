module ID (

    //Decode Signals
    output logic [6:0] o_Funct7,
    output logic [2:0] o_Funct3,
    output logic [6:0] o_OPCode,


    //Immediate Generator Signals
`ifndef YOSYS
    output data_t o_IG_extendedImmediate,
`else 
    output logic [`WORD_SIZE -1:0] o_IG_extendedImmediate,
`endif

    //CSR
`ifndef YOSYS
    output data_t o_CSR_rd,
`else 
    output logic [WORD_SIZE-1:0] o_CSR_rd,
`endif
    input  logic        i_CSR_en,
    
//Register File Signals
`ifdef YOSYS
    output data_t o_RF_rd1,
    output data_t o_RF_rd2,
    input  data_t i_RF_wd,
`else 
    output logic [`WORD_SIZE -1:0] o_RF_rd1,
    output logic [`WORD_SIZE -1:0] o_RF_rd2,
    input  logic [`WORD_SIZE -1:0] i_RF_wd,
`endif
    input  logic i_RF_wen,

    //Instruction
`ifndef YOSYS
    input  data_t i_instruction,
`else 
    input  logic [`WORD_SIZE -1:0] i_instruction,
`endif
    
    input i_clk,    // Clock
    input i_rstn  // Asynchronous reset active low
   
);

    //Register File Signals
    logic [4:0] RF_rnum1;
    logic [4:0] RF_rnum2;
    logic [4:0] RF_wnum;

        //CSR
`ifndef YOSYS
    data_t   CSR_wd;
`else 
    logic [WORD_SIZE-1:0]  CSR_wd;
`endif
    logic [11:0] CSR_addr;
    logic [2:0]  CSR_Funct3;

    //"Decode" instruction (Register File)
    assign RF_rnum1 = i_instruction[19:15];
    assign RF_rnum2 = i_instruction[24:20];
    assign RF_wnum  = i_instruction[11:7];

    //"Decode" instruction (F7 and F3)
    assign o_Funct3 = i_instruction[14:12];
    assign o_Funct7 = i_instruction[31:25];

    //"Decode" instruction (Main Control)
    assign o_OPCode = i_instruction[6:0];

    //CSR
    //assign CSR_wd =;

    REGISTER_FILE register_file (
        .o_Rd1(o_RF_rd1), 
        .o_Rd2(o_RF_rd2), 
        .i_Rnum1(RF_rnum1), 
        .i_Rnum2(RF_rnum2), 
        .i_Wen(i_RF_wen), 
        .i_Wnum(RF_wnum), 
        .i_Wd(i_RF_wd), 
        .i_clk(i_clk),
        .i_rstn(i_rstn)
    );

    CSR csr (
        .o_rd(o_CSR_rd),
        .i_addr(CSR_addr),
        .i_wd(CSR_wd),
        .i_en(i_CSR_en),
        .i_Funct3(o_Funct3),
        .i_clk(i_clk),
        .i_rstn(i_rstn)
    );

    IMM_GENERATOR imm_generator (
        .o_ExtendedImmediate(o_IG_extendedImmediate), 
        .i_Instruction(i_instruction)
    );

endmodule