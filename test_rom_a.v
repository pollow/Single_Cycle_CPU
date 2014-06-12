`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:44:55 05/22/2014
// Design Name:   ROM_A
// Module Name:   C:/Users/Deus/Windows Sync/Xilinx Workspace/Single/test_rom_a.v
// Project Name:  Single
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ROM_A
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_rom_a;

	// Inputs
	reg [31:0] addr;

	// Outputs
	wire [31:0] inst;

	// Instantiate the Unit Under Test (UUT)
	ROM_A uut (
		.addr(addr), 
		.inst(inst)
	);

	initial begin
		// Initialize Inputs
		addr = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here
		
	end
	
	always @* begin
		#10 addr <= addr + 1;
	end
      
endmodule

