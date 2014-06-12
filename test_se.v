`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:56:49 05/22/2014
// Design Name:   sign_extend
// Module Name:   C:/Users/Deus/Windows Sync/Xilinx Workspace/Single/test_se.v
// Project Name:  Single
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sign_extend
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_se;

	// Inputs
	reg [15:0] imm_number;

	// Outputs
	wire [31:0] extended_number;

	// Instantiate the Unit Under Test (UUT)
	sign_extend uut (
		.imm_number(imm_number), 
		.extended_number(extended_number)
	);

	initial begin
		// Initialize Inputs
		imm_number = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		imm_number = 16'b0010101010110101;
		
		#100;
		imm_number = 16'b1010101010110101;

	end
      
endmodule

