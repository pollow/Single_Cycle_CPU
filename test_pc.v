`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:36:39 05/20/2014
// Design Name:   program_counter
// Module Name:   C:/Users/Deus/Windows Sync/Xilinx Workspace/Single/test_pc.v
// Project Name:  Single
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: program_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_pc;

	// Inputs
	reg clk;
	reg [31:0] pc_next;

	// Outputs
	wire [31:0] pc_now;

	// Instantiate the Unit Under Test (UUT)
	program_counter uut (
		.clk(clk), 
		.pc_next(pc_next), 
		.pc_now(pc_now)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		pc_next = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
	end
     
	always @* pc_next <= pc_now + 4;
	
	always #10 clk = ~clk;
endmodule

