`timescale 1ns/1ps 

`include "ALU_CONTROL.vh"
`include "OPCODES_DEFINES.vh"
`include "PARAMETERS.vh"
`include "PROJECT_CONFIG.vh"


`include "memory_if.sv"
`include "reg_file_if.sv"

`define CLK_PERIOD 40 //25MHz

`define REGISTER_FILE_PATH dut.core.register_file
`define DATA_MEMORY_PATH dut.data_memory
`define INST_MEMORY_PATH dut.instruction_memory

module tb;

    import tb_pkg::*;

    //Parameters
    parameter IM_FILE="dafault";

    //Classes
    test test0;

    //Inputs
    logic i_clk;
    logic i_rstn;

    //Testbench Attributes

    //task verification();
    //    begin 
    //        case (model.instruction_encoded[6:0])
    //            `OP_R_TYPE : begin 
    //                if(`REGISTER_FILE_PATH.x[model.rd] !== model.get_reg(model.rd)) begin
    //                    $display("dut.x[%d] = %d, model.x[%d] = %d", model.get_rd(), `REGISTER_FILE_PATH.x[model.get_rd()], model.get_rd(),  model.get_reg(model.get_rd()));
    //                    $display("|R-type| **ERROR ");
    //                end
    //            end
    //        
    //            `OP_I_TYPE : begin 
    //                if(`REGISTER_FILE_PATH.x[model.get_rd()] !== model.get_reg(model.get_rd())) begin
    //                    $display("dut.x[%d] = %d, model.x[%d] = %d", model.get_rd(), `REGISTER_FILE_PATH.x[model.get_rd()], model.get_rd(),  model.get_reg(model.get_rd()));
    //                    $display("|I-type| **ERROR ");
    //                end
    //            end
    //        
    //            `OP_I_L_TYPE : begin 
    //                if(`REGISTER_FILE_PATH.x[model.get_rd()] !== model.get_reg(model.get_rd())) begin
    //                    $display("dut.x[%d] = %d, model.x[%d] = %d", model.get_rd(), `REGISTER_FILE_PATH.x[model.get_rd()], model.get_rd(),  model.get_reg(model.get_rd()));
    //                    $display("|I_L-type| **ERROR ");
    //                end
    //            end
    //            `OP_S_TYPE : begin
    //                if(`DATA_MEMORY_PATH.mem[(model.get_imm()+model.get_rs1())>>2] !== model.get_mem(signed'(model.get_imm())+model.get_rs1())) begin
    //                    $display("dut.dmem[%d] = %d, model.dmem[%d] = %d", (model.get_imm()+model.get_rs1())>>2, `DATA_MEMORY_PATH.mem[(model.get_imm()+model.get_rs1())>>2], (model.get_imm()+model.get_rs1())>>2,  model.get_mem((model.get_imm()+model.get_rs1())));
    //                    $display("|S-type| **ERROR ");
    //                end
    //            end
    //        
    //            `OP_B_TYPE : begin 
    //            end
    //        
    //            `OP_JAL : begin            
    //             end
    //        
    //            `OP_JALR : begin 
    //            end
    //        
    //            `OP_LUI : begin 
    //            end
    //            `OP_AUIPC : begin 
    //            end
    //            default : /* default */;
    //        endcase
    //    end
    //endtask

    //Interfaces
    bind `INST_MEMORY_PATH memory_if memory_if0(.clk(i_clk), .rstn(i_rstn), .addr(i_Addr), .rdata(o_Instruction)); //Binding: Instruction Memory Interface
    bind `DATA_MEMORY_PATH memory_if memory_if1(.clk(i_clk), .rstn(i_rstn), .addr(i_Addr), .rdata(o_Rd), .wdata(i_Wd), .ren(i_Ren), .wen(i_Wen)); //Binding: Data Memory Interface
    bind `REGISTER_FILE_PATH reg_file_if reg_file_if0(.clk(i_clk), .rn1(i_Rnum1), .rn2(i_Rnum2), .wn(i_Wnum), .rd1(o_Rd1), .rd2(o_Rd2), .wd(i_Wd), .wen(i_Wen)); //Binding: Register File Interface
    test_if test_if0(.clk(clk), .rstn(rstn));
    //DUT
    DATAPATH #(IM_FILE) dut (
        .i_clk(i_clk),
        .i_rstn(i_rstn)
    );

    initial begin
        $display("IM_FILE: %s", IM_FILE);
        test0 = new(test_if0, `INST_MEMORY_PATH.memory_if0, `DATA_MEMORY_PATH.memory_if1, `REGISTER_FILE_PATH.reg_file_if0);
        i_clk = 1'b0;
        test0.run();
    end

    //Clock generation
    always begin
        #(`CLK_PERIOD/2) i_clk = ~i_clk;
    end

    //Reset generation
    initial begin 
        #5;
        i_rstn <= 1'b0;
        #5;
        i_rstn <= 1'b1;
    end
       
endmodule

