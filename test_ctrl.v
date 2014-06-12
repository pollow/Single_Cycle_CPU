`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:00:13 05/22/2014
// Design Name:   control
// Module Name:   C:/Users/Deus/Windows Sync/Xilinx Workspace/Single/test_ctrl.v
// Project Name:  Single
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ctrl;

	// Inputs
	reg [5:0] op;
	reg [5:0] funct;

	// Outputs
	wire RegDst;
	wire RegWrite;
	wire ALUSrc;
	wire MemRead;
	wire MemWrite;
	wire MemtoReg;
	wire Jump;
	wire JumpReg;
	wire Branch;
	wire [3:0] ALUCtrl;

	// Instantiate the Unit Under Test (UUT)
	control uut (
		.op(op), 
		.funct(funct), 
		.RegDst(RegDst), 
		.RegWrite(RegWrite), 
		.ALUSrc(ALUSrc), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.MemtoReg(MemtoReg), 
		.Jump(Jump), 
		.JumpReg(JumpReg), 
		.Branch(Branch), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		op = 0;
		funct = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#20;
		op = 6'h08;
		funct = 6'h02;
		#20;
		op = 6'h0C;
		funct = 6'h02;
		#20;
		op = 6'h0D;
		funct = 6'h02;
		#20;
		op = 6'h0E;
		funct = 6'h02;
		#20;
		op = 6'h0F;
		funct = 6'h02;
		#20;
		op = 6'h23;
		funct = 6'h02;
		#20;
		op = 6'h2B;
		funct = 6'h02;
		#20;
		op = 6'h04;
		funct = 6'h02;
		#20;
		op = 6'h05;
		funct = 6'h02;
		#20;
		op = 6'h0A;
		funct = 6'h02;
		#20;
		op = 6'h00;
		funct = 6'h32;
		#20;
		funct = 6'h34;
		#20;
		funct = 6'h36;
		#20;
		funct = 6'h37;
		#20;
		funct = 6'h38;
		#20;
		funct = 6'h39;
		#20;
		funct = 6'h42;
		#20;
		funct = 6'h02;
		#20;
		funct = 6'h00;
		
	end
      
endmodule

