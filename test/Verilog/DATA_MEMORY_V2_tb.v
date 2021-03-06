`timescale 1ns / 1ps
//`define R_TEST//Read Test
`define W_B_TEST//Write Byte Test

//@TODO: Fix W_B_TEST and make another tests

module DATA_MEMORY_V2_tb;
	parameter HEIGHT = 256;//Memory height
	parameter FILE = "test.r32i";
	// Inputs
	reg [31:0] i_Wd;
	reg [31:0] i_Addr;
	reg [3:0] i_Wen;
	reg i_Ren;
	reg i_clk;

	// Outputs
	wire [31:0] o_Rd;

	// Instantiate the Unit Under Test (UUT)
	DATA_MEMORY_V2 dut (
		.o_Rd(o_Rd), 
		.i_Wd(i_Wd), 
		.i_Addr(i_Addr), 
		.i_Wen(i_Wen), 
		.i_Ren(i_Ren), 
		.i_clk(i_clk)
	);

	integer i,j;
	reg [31:0] mem_test [HEIGHT-1:0];//Test Memory
	reg [31:0] Rd_test, Wr_test;//Test Rd

	initial begin
		$readmemh(FILE, mem_test);//Initialize Memory
		i_Wd = 0;
		i_Addr = 0;
		i_Wen = 0;
		i_Ren = 0;
		i_clk = 0;

		`ifdef R_TEST
		i_Ren = 1;
		for(i=0;i<HEIGHT;i = i+1) begin
			Rd_test = mem_test[i_Addr>>2];//Compose data read
			#10;
			if(o_Rd !== Rd_test) begin
				$display("Interaction: ", i);
				$display("Read TEST: %B",Rd_test, "  Read: %B", o_Rd);
				$display("ERROR");
				$finish;
			end
			i_Addr = i_Addr+4;//Increment Addr
		end
		i_Ren = 0;
		i_Addr = 0;
		`endif

		`ifdef W_B_TEST
		for(i=0;i<HEIGHT;i = i+1) begin
			for(j=0;j<4;j = j+1) begin
				i_Wen = 4'b0001<<j;
				Wr_test = ($random%8)<<(j*8);
				i_Wd = Wr_test;
				#10;
				i_Wen = 0;
				i_Ren = 1;
				Rd_test = o_Rd<<(j*8);
				#10;
				i_Ren = 0;
			end
			if (Wr_test ==! Rd_test) begin
				$display("Interaction: ", i);
				$display("ERROR");
				$finish;
			end
			i_Addr = i_Addr+4;//Increment Addr
		end
		`endif
		$finish;

	end
    always begin
		#5 i_clk = ~i_clk;
	end
endmodule

