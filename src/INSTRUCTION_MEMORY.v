`timescale 1ns / 1ps
`include "PARAMETERS.vh"

module INSTRUCTION_MEMORY(
    output [`WORD_SIZE:0] o_Instruction,
    input [`WORD_SIZE:0] i_Addr
    );

	parameter HEIGHT = `IM_DEPTH;//Memory height
	parameter FILE = `IM_FILE;

	reg [7:0] mem [HEIGHT-1:0];//Memory: Word: 1byte

	/*
		The instruction memory is initialized with the hexadecimal code generated by the assembler.
	It's used one C code (Mount.c) to generate this initilization.
	*/
	initial begin
		$readmemh(FILE, mem);//Initialize Memory
	end
	
	assign o_Instruction = {mem[i_Addr+3], mem[i_Addr+2], mem[i_Addr+1], mem[i_Addr]};//One instruction has 32 bits


endmodule
