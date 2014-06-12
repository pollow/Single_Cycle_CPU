`define CONTROL_SIGNAL {RegDst, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Jump, Branch, Equal, JumpLink}
module Single_Cycle_CPU(
    input clk_in,
    input btn_t,
    input [5:0]sw,
    output [6:0]seg,
    output [3:0]an
);
    wire [31:0]pc_now, inst, read_data_1, read_data_2, debug_output, alu_output, pc_t1, pc_t2, imm, memory_out;
    wire [31:0]mux_out_2, mux_out_3, mux_out_5, mux_out_6, mux_out_7;
    wire [4:0] mux_out_1;
	wire [1:0] RegDst, Jump;
    wire btn, clk_100M, RegWrite, ALUSrc, MemRead, MemtoReg, MemWrite, JumpReg, Branch, Equal, JumpLink, zero, mux_out_4;
    wire [3:0]ALUCtrl;
    reg clk_25M, clk_50M;
    reg [15:0]disp_num;

    assign clk_100M = clk_in;
    
    initial begin
        clk_50M <= 0;
        clk_25M <= 0;
    end
    
    always @(posedge clk_in) begin
        clk_50M <= ~clk_50M;
    end
    
    always @(posedge clk_50M) begin
        clk_25M <= ~clk_25M;
    end

    program_counter M0(
        .clk(clk_25M),
        .pc_next(mux_out_6),
        .pc_now(pc_now)
    );

    ROM_A M1(
        .addr({2'b00, pc_now[31:2]}),
        .inst(inst)
    );

    control M2(
        .op(inst[31:26]),
        .funct(inst[5:0]),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Jump(Jump),
        .Branch(Branch),
        .Equal(Equal),
        .JumpLink(JumpLink),
        .ALUCtrl(ALUCtrl)
    );

    register_file M3(
        .clk(clk_25M),
        .read_register_1(inst[25:21]),
        .read_register_2(inst[20:16]),
        .write_register(mux_out_1),
        .debug_input(sw[4:0]),
        .write_data(mux_out_7),
        .RegWrite(RegWrite),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .debug_output(debug_output)
    );

    alu M4(
        .alu_ctl(ALUCtrl),
        .A(read_data_1),
        .B(mux_out_2),
        .zero(zero),
        .result(alu_output)
    );

    adder M5(
        .A(pc_now),
        .B(32'd4),
        .result(pc_t1)
    );

    adder M6(
        .A(pc_t1),
        .B({imm[29:0], 2'b00}),
        .result(pc_t2)
    );

    sign_extend M7(
        .imm_number(inst[15:0]),
        .extended_number(imm)
    );

    RAM_A M8(
        .clk(clk_100M),
        .a({2'b00, alu_output[31:2]}),
        .d(read_data_2),
        .we(MemWrite),
        .spo(memory_out)
     );
     
     always @(*) begin
        if (sw[5]) begin
               disp_num <= debug_output[31:16];
          end else begin
              disp_num <= debug_output[15:0];
          end
     end
     
    display M9(
        .clk(clk_100M),
        .disp_num(disp_num),
        .seg(seg),
        .anode(an)
    );

     mux_4_to_1_5 U1(
         .A(inst[20:16]),
         .B(inst[15:11]),
         .C(5'd31),
         .D(5'b0),
         .enable(RegDst),
         .O(mux_out_1)
     );

     mux_2_to_1_32 U2(
         .A(read_data_2),
         .B(imm),
         .enable(ALUSrc),
         .O(mux_out_2)
     );

     mux_2_to_1_32 U3(
         .A(alu_output),
         .B(memory_out),
         .enable(MemtoReg),
         .O(mux_out_3)
     );

     mux_2_to_1_1 U4(
        .A(zero),
        .B(~zero),
        .enable(Equal),
        .O(mux_out_4)
    );

     mux_2_to_1_32 U5(
         .A(pc_t1),
         .B(pc_t2),
         .enable(Branch & mux_out_4),
         .O(mux_out_5)
     );
     
     mux_4_to_1_32 U6(
         .A(mux_out_5),
         .B({pc_t1[31:28],inst[25:0], 2'b00}),
         .C(read_data_1),
         .D(32'b0),
         .enable(Jump),
         .O(mux_out_6)
     );

     mux_2_to_1_32 U7(
        .A(mux_out_3),
        .B(pc_t1),
        .enable(JumpLink),
        .O(mux_out_7)
    );

     glitch_filter U8(
        .clk(clk_100M),
        .key_in(btn_t),
        .key_out(btn)
     );

endmodule

module glitch_filter(
    input clk, key_in,
    output key_out
);

    reg [21:0] count_low;
    reg [21:0] count_high;
    reg key_out_reg;

    always @(posedge clk)
        if(key_in ==1'b0)
            count_low <= count_low + 1;
        else
            count_low <= 0;

    always @(posedge clk)
        if(key_in ==1'b1)
            count_high <= count_high + 1;
        else
            count_high <= 0;

    always @(posedge clk)
        if(count_high == 4)
            key_out_reg <= 1;
        else if(count_low == 4)
            key_out_reg <= 0;

    assign key_out = key_out_reg;

endmodule

module mux_2_to_1_1(
    input A,B,
    input enable,
    output reg O
);

    always @* begin
        if (enable) O <= B;
        else O <= A;
    end

endmodule

module mux_2_to_1_5(
    input [4:0] A,B,
    input enable,
    output reg[4:0] O
);

    always @* begin
        if (enable) O <= B;
        else O <= A;
    end

endmodule

module mux_4_to_1_5(
    input [4:0] A,B,C,D,
    input [1:0] enable,
    output reg[4:0] O
);

    always @* begin
        case (enable) 
            2'b00 : begin
                O <= A;
            end
            2'b01 : begin
                O <= B;
            end
            2'b10 : begin
                O <= C;
            end
            2'b11 : begin
                O <= D;
            end
        endcase
    end

endmodule

module mux_2_to_1_32(
    input [31:0] A,B,
    input enable,
    output reg[31:0] O
);

    always @* begin
        if (enable) O <= B;
        else O <= A;
    end

endmodule

module mux_4_to_1_32(
    input [31:0] A,B,C,D,
    input [1:0] enable,
    output reg[31:0] O
);

    always @* begin
        case (enable) 
            2'b00 : begin
                O <= A;
            end
            2'b01 : begin
                O <= B;
            end
            2'b10 : begin
                O <= C;
            end
            2'b11 : begin
                O <= D;
            end
        endcase
    end

endmodule

module ROM_A(
    input [31:0] addr,
    output [31:0] inst
);

    reg [31:0]instructions[18:0];
    
    initial begin
        instructions[0] = 32'h00000000;
        instructions[1] = 32'h3c0c0064;
        instructions[2] = 32'h01294826;
        instructions[3] = 32'h014a5026;
        instructions[4] = 32'h016b5826;
        instructions[5] = 32'h21290064;
        instructions[6] = 32'h2149ff9d;
        instructions[7] = 32'had690000;
        instructions[8] = 32'h8d6b0000;
        instructions[9] = 32'h01404820;
        instructions[10] = 32'h112a0001;
        instructions[11] = 32'h152b0002;
        instructions[12] = 32'h00000001;
        instructions[13] = 32'h012b882a;
        instructions[14] = 32'h297200c8;
        instructions[15] = 32'h01695822;
        instructions[16] = 32'h000b5842;
        instructions[17] = 32'h01200000;
        instructions[18] = 32'h00000000;
    end
    
    assign inst = instructions[addr];   

endmodule

module register_file(
    input clk,
    input [4:0]read_register_1,
    input [4:0]read_register_2,
    input [4:0]write_register,
    input [4:0]debug_input,
    input [31:0]write_data,
    input RegWrite,
    output [31:0]read_data_1,
    output [31:0]read_data_2,
    output [31:0]debug_output
);
    
    reg [31:0]registers[31:0];

    initial begin
        registers[0] = 32'h0;
        registers[1] = 32'h0;
        registers[2] = 32'h0;
        registers[3] = 32'h0;
        registers[4] = 32'h0;
        registers[5] = 32'h0;
        registers[6] = 32'h0;
        registers[7] = 32'h0;
        registers[8] = 32'h0;
        registers[9] = 32'h0;
        registers[10] = 32'h0;
        registers[11] = 32'h0;
        registers[12] = 32'h0;
        registers[13] = 32'h0;
        registers[14] = 32'h0;
        registers[15] = 32'h0;
        registers[16] = 32'h0;
        registers[17] = 32'h0;
        registers[18] = 32'h0;
        registers[19] = 32'h0;
        registers[20] = 32'h0;
        registers[21] = 32'h0;
        registers[22] = 32'h0;
        registers[23] = 32'h0;
        registers[24] = 32'h0;
        registers[25] = 32'h0;
        registers[26] = 32'h0;
        registers[27] = 32'h0;
        registers[28] = 32'h0;
        registers[29] = 32'h0;
        registers[30] = 32'h0;
        registers[31] = 32'h0;    
    end

    assign debug_output = registers[debug_input];
    assign read_data_1 = registers[read_register_1];
    assign read_data_2 = registers[read_register_2];
    
    always @(posedge clk) begin
        if (RegWrite) begin
            registers[write_register] = write_data;
        end
    end
endmodule

module sign_extend(
    input [15:0]imm_number,
    output [31:0]extended_number
);

    assign extended_number = {{16{imm_number[15]}}, imm_number};

endmodule

module adder(
    input [31:0]A, B,
    output [31:0]result
);

    assign result = A + B;

endmodule

module alu(
    input [3:0]alu_ctl,
    input signed [31:0]A, B,
    output zero,
    output reg [31:0]result
);

    assign zero = (result == 0);
    always @* begin
        case (alu_ctl) 
            4'b0001 : result <= A + B;
            4'b0010 : result <= A - B;
            4'b0011 : result <= A & B;
            4'b0100 : result <= A | B;
            4'b0101 : result <= A ^ B;
            4'b0110 : result <= ~(A | B);
            4'b0111 : result <= B >> 1;
            4'b1000 : result <= {B[15:0], 16'b0};
            4'b1001 : result <= (A < B);
            default : result <= 0;
        endcase
    end
endmodule

module program_counter(
    input clk,
    input [31:0]pc_next,
    output reg [31:0]pc_now
);
     initial begin
        pc_now <= 0;
     end

    always @(posedge clk) begin
        pc_now <= pc_next;
    end

endmodule

module control(
    input [5:0]op,
    input [5:0]funct,
    output reg [1:0]RegDst,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg [1:0]Jump,
    output reg Branch,
    output reg Equal,
    output reg JumpLink,
    output reg [3:0]ALUCtrl
);
    // RegDst 0 : select from rt, 1 : select from rd
    // RegWrite 0 : None, 1 : Write data into register file
    // ALUSrc 0 : the second operand of ALU come from register file, 1 : come
    // from immediate number.
    // MemRead read data out from memory.
    // MemWrite write data into memory
    // MemtoReg output of memory write into registe file

    always @* begin
     case(op)
        6'h08 : begin //addi
            `CONTROL_SIGNAL <= 12'b0011000000X0;
            ALUCtrl <= 4'b0001; // add
            end
        6'h0C : begin //andi
            `CONTROL_SIGNAL <= 12'b0011000000X0;
            ALUCtrl <= 4'b0011; // and
            end
        6'h0D : begin //ori
            `CONTROL_SIGNAL <= 12'b0011000000X0;
            ALUCtrl <= 4'b0100; // or
            end
        6'h0E : begin //xori
            `CONTROL_SIGNAL <= 12'b0011000000X0;
            ALUCtrl <= 4'b0101; // xor
            end
        6'h0F : begin //lui
            `CONTROL_SIGNAL <= 12'b0011000000X0;
            ALUCtrl <= 4'b1000; // lui
            end
        6'h23 : begin //lw
            `CONTROL_SIGNAL <= 12'b0011101000X0;
            ALUCtrl <= 4'b0001; // add
            end
        6'h2B : begin //sw
            `CONTROL_SIGNAL <= 12'bXX01011000X0;
            ALUCtrl <= 4'b0001; // add
            end
        6'h04 : begin //beq
            `CONTROL_SIGNAL <= 12'b000000000100;
            ALUCtrl <= 4'b0010; // sub
            end
        6'h05 : begin //bne
            `CONTROL_SIGNAL <= 12'b000000000110;
            ALUCtrl <= 4'b0010; // sub
            end
        6'h0A : begin //slti
            `CONTROL_SIGNAL <= 12'b0011000000X0;
            ALUCtrl <= 4'b1001; // slt
            end
        6'h02 : begin //j
            `CONTROL_SIGNAL <= 12'bXX0X000010X0;
            ALUCtrl <= 4'b0000; 
            end
        6'h03 : begin //jal
            `CONTROL_SIGNAL <= 12'b101X000010X1;
            ALUCtrl <= 4'b0000; 
            end
        6'h00 :  //R-Type
            case(funct) 
                6'd32 : begin 
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b0001; // add
                    end
                6'd34 : begin 
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b0010; // sub
                    end
                6'd36 : begin 
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b0011; // and
                    end
                6'd37 : begin
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b0100; // or
                    end
                6'd38 : begin
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b0101; // xor
                    end
                6'd39 : begin 
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b0110; // nor
                    end
                6'd42 : begin 
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b1001; // slt
                    end
                6'd02 : begin 
                    `CONTROL_SIGNAL <= 12'b0110000000X0;
                    ALUCtrl <= 4'b0111; // srl
                    end
                6'd08 : begin  // jr
                    `CONTROL_SIGNAL <= 12'b000000010XX0;
                    ALUCtrl <= 4'b0000; 
                    end
                6'd09 : begin  // jalr
                    `CONTROL_SIGNAL <= 12'b011000010XX1;
                    ALUCtrl <= 4'b0000; 
                    end
                default : begin
                    `CONTROL_SIGNAL <= 12'b0;
                    ALUCtrl <= 4'b0; // xor
                    end
            endcase
        default : begin
            `CONTROL_SIGNAL <= 12'b0;
            ALUCtrl <= 4'b0; // xor
            end
    endcase
 end

endmodule

module display(
    input clk,
    input [15:0]disp_num,
    output reg [6:0]seg,
    output reg [3:0]anode
);

    reg [26:0]tick;
    reg [1:0]an;
    reg [3:0]num;
    reg t;
    
    initial begin
        an <= 2'b00;
        tick <= 0;
    end
    
    always @(posedge clk)
        tick = tick+1;
    
    always @(posedge tick[16]) 
        an = an + 1;
    
    always @(an) begin
        anode <= ~(4'b1<<an);
        case(an) 
            2'b00: num = disp_num[3:0];
            2'b01: num = disp_num[7:4];
            2'b10: num = disp_num[11:8];
            2'b11: num = disp_num[15:12];
            default:;
        endcase
    end

    always @(anode or num) begin
        case(num)
            4'h0 : seg[6:0] = 7'b1000000;
            4'h1 : seg[6:0] = 7'b1111001;
            4'h2 : seg[6:0] = 7'b0100100;
            4'h3 : seg[6:0] = 7'b0110000;
            4'h4 : seg[6:0] = 7'b0011001;
            4'h5 : seg[6:0] = 7'b0010010;
            4'h6 : seg[6:0] = 7'b0000010;
            4'h7 : seg[6:0] = 7'b1111000;
            4'h8 : seg[6:0] = 7'b0000000;
            4'h9 : seg[6:0] = 7'b0010000;
            4'hA : seg[6:0] = 7'b0001000;
            4'hB : seg[6:0] = 7'b0000011;
            4'hC : seg[6:0] = 7'b1000110;
            4'hD : seg[6:0] = 7'b0100001;
            4'hE : seg[6:0] = 7'b0000110;
            default : seg[6:0] = 7'b0001110;
        endcase
    end

endmodule
