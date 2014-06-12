`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:13:58 05/20/2014
// Design Name:   Single_Cycle_CPU
// Module Name:   C:/Users/Deus/Windows Sync/Xilinx Workspace/Single/test_t.v
// Project Name:  Single
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Single_Cycle_CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_t;

	// Inputs
	reg clk_in;
	reg btn_t;
	reg [5:0] sw;

	// Outputs
	wire [6:0] seg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	Single_Cycle_CPU uut (
		.clk_in(clk_in), 
		.btn_t(btn_t), 
		.sw(sw), 
		.seg(seg), 
		.an(an)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		btn_t = 0;
		sw = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
   always #10 clk_in = ~clk_in;
endmodule

