`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:21:30 05/20/2014
// Design Name:   alu
// Module Name:   C:/Users/Deus/Windows Sync/Xilinx Workspace/Single/test_alu.v
// Project Name:  Single
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_alu;

	// Inputs
	reg [3:0] alu_ctl;
	reg [31:0] A;
	reg [31:0] B;

	// Outputs
	wire zero;
	wire [31:0] result;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.alu_ctl(alu_ctl), 
		.A(A), 
		.B(B), 
		.zero(zero), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		alu_ctl = 0;
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		A = 32'h01234567;
		B = 32'h3456789A;
		# 100;
		alu_ctl = 4'b0001;
		# 100;
		alu_ctl = 4'b0010;
		# 100;
		alu_ctl = 4'b0011;
		# 100;
		alu_ctl = 4'b0100;
		# 100;
		alu_ctl = 4'b0101;
		# 100;
		alu_ctl = 4'b0110;
		# 100;
		alu_ctl = 4'b0111;
		# 100;
		alu_ctl = 4'b1000;
		# 100;
		alu_ctl = 4'b1001;
		# 100;
	end
      
endmodule

