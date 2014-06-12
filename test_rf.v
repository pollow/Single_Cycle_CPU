`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:04:58 05/20/2014
// Design Name:   register_file
// Module Name:   C:/Users/Deus/Windows Sync/Xilinx Workspace/Single/test_rf.v
// Project Name:  Single
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register_file
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_rf;

	// Inputs
	reg clk;
	reg [4:0] read_register_1;
	reg [4:0] read_register_2;
	reg [4:0] write_register;
	reg [4:0] debug_input;
	reg [31:0] write_data;
	reg RegWrite;

	// Outputs
	wire [31:0] read_data_1;
	wire [31:0] read_data_2;
	wire [31:0] debug_output;

	// Instantiate the Unit Under Test (UUT)
	register_file uut (
		.clk(clk), 
		.read_register_1(read_register_1), 
		.read_register_2(read_register_2), 
		.write_register(write_register), 
		.debug_input(debug_input), 
		.write_data(write_data), 
		.RegWrite(RegWrite), 
		.read_data_1(read_data_1), 
		.read_data_2(read_data_2), 
		.debug_output(debug_output)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		read_register_1 = 0;
		read_register_2 = 0;
		write_register = 0;
		debug_input = 0;
		write_data = 0;
		RegWrite = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always @* #10 clk = ~clk;
	always @(posedge clk) begin
		read_register_1 = read_register_1 + 1;
	end
endmodule

