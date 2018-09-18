// Behavioral model of MIPS - pipelined implementation

module alu (op,a,b,result,zero);
   input [15:0] a; // 16 bit a value
   input [15:0] b;
   input [2:0] op; // opcode is 3 bits
   output [15:0] result; // 16 bit a and b computed to a 16 bit result
   output zero; // zero of course can just be 1 bit
   wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16; // 16 wires, one for each bit

   // Implementation of a 16bit ALU
   ALU1   alu0  (a[0], b[0], op[2], op[1:0],set,   op[2],c1, result[0]),
          alu1  (a[1], b[1], op[2], op[1:0],1'b0,  c1,   c2, result[1]),
          alu2  (a[2], b[2], op[2], op[1:0],1'b0,  c2,   c3, result[2]),
          alu3  (a[3], b[3], op[2], op[1:0],1'b0,  c3,   c4, result[3]),
          alu4  (a[4], b[4], op[2], op[1:0],1'b0,  c4,   c5, result[4]),
          alu5  (a[5], b[5], op[2], op[1:0],1'b0,  c5,   c6, result[5]),
          alu6  (a[6], b[6], op[2], op[1:0],1'b0,  c6,   c7, result[6]),
          alu7  (a[7], b[7], op[2], op[1:0],1'b0,  c7,   c8, result[7]),
          alu8  (a[8], b[8], op[2], op[1:0],1'b0,  c8,   c9, result[8]),
          alu9  (a[9], b[9], op[2], op[1:0],1'b0,  c9,   c10,result[9]),
          alu10 (a[10],b[10],op[2], op[1:0],1'b0,  c10,  c11,result[10]),
          alu11 (a[11],b[11],op[2], op[1:0],1'b0,  c11,  c12,result[11]),
          alu12 (a[12],b[12],op[2], op[1:0],1'b0,  c12,  c13,result[12]),
          alu13 (a[13],b[13],op[2], op[1:0],1'b0,  c13,  c14,result[13]),
          alu14 (a[14],b[14],op[2], op[1:0],1'b0,  c14,  c15,result[14]);
   ALUmsb alu15 (a[15],b[15],op[2], op[1:0],1'b0,  c15,  c16,result[15],set);

   or or1(or01, result[0],result[1]);
   or or2(or23, result[2],result[3]);
   nor nor1(zero,or01,or23);

endmodule

// 1-bit ALU for bits 0-14
module ALU1 (a,b,binvert,op,less,carryin,carryout,result);
   input a,b,less,carryin,binvert;
   input [1:0] op;
   output carryout,result;
   wire sum, a_and_b, a_or_b, b_inv;

   not not1(b_inv, b);
   mux2x1 mux1(b,b_inv,binvert,b1);
   and and1(a_and_b, a, b);
   or or1(a_or_b, a, b);
   fulladder adder1(sum,carryout,a,b1,carryin);
   mux4x1 mux2(a_and_b,a_or_b,sum,less,op[1:0],result);

endmodule

// 1-bit ALU for the most significant bit
module ALUmsb (a,b,binvert,op,less,carryin,carryout,result,sum);
   input a,b,less,carryin,binvert;
   input [1:0] op;
   output carryout,result,sum;
   wire sum, a_and_b, a_or_b, b_inv;

   not not1(b_inv, b);
   mux2x1 mux1(b,b_inv,binvert,b1);
   and and1(a_and_b, a, b);
   or or1(a_or_b, a, b);
   fulladder adder1(sum,carryout,a,b1,carryin);
   mux4x1 mux2(a_and_b,a_or_b,sum,less,op[1:0],result);

endmodule

// implementing 4 16 bit registers
module reg_file (rr1,rr2,wr,wd,regwrite,rd1,rd2,clock);
   input [1:0] rr1,rr2,wr;
   input [15:0] wd;
   input regwrite,clock;
   output [15:0] rd1,rd2;
   wire [15:0] q1,q2,q3;

// registers
   D_flip_flop_16b r1 (wd,c1,q1),
                   r2 (wd,c2,q2),
                   r3 (wd,c3,q3);

// output port
   mux4x1_16b  mux1 (16'b0,q1,q2,q3,rr1,rd1),
                mux2 (16'b0,q1,q2,q3,rr2,rd2);

// input port
   decoder dec(wr[1],wr[0],w3,w2,w1,w0);

   and a (regwrite_and_clock,regwrite,clock);

   and a1 (c1,regwrite_and_clock,w1),
       a2 (c2,regwrite_and_clock,w2),
       a3 (c3,regwrite_and_clock,w3);
endmodule

// D flip flop D_Latch
module D_latch(D,C,Q);
   input D,C;
   output Q;
   wire x,y,D1,Q1;
   nand nand1 (x,D, C),
        nand2 (y,D1,C),
        nand3 (Q,x,Q1),
        nand4 (Q1,y,Q);
   not  not1  (D1,D);
endmodule

// 1 bit d flip flop
module D_flip_flop(D,CLK,Q);
   input D,CLK;
   output Q;
   wire CLK1, Y;
   not  not1 (CLK1,CLK);
   D_latch D1(D,CLK, Y),
           D2(Y,CLK1,Q);
endmodule

// implementation of a 16bit d flip flop
module D_flip_flop_16b(D,CLK,Q);
	input CLK;
	input [15:0] D;
	output [15:0] Q;
	genvar i; // increment value. must be declared as genvar
	generate // must use "generate" and put our for loop inside that in order to have it at all in a module
		for(i=0; i<=15; i=i+1) begin : d_loop
			D_flip_flop r(D[i],CLK,Q[i]); // implement 16 d flip flops with a for loop
		end // end for loop
	endgenerate // end generate block
endmodule


// 1bit 4x1 mux implementation
module mux4x1(i0,i1,i2,i3,select,out);
	input i0,i1,i2,i3; // four inputs
	input [1:0] select; // select is 2 bits, since there's 4 inputs
	output out; // one output
	not n(ns0,select[0]),
		n(ns1,select[1]);

	and a0(q0,ns0,ns1,i0),
		a1(q1,select[0],ns1,i1),
		a2(q2,ns0,select[1],i2),
		a3(q3,select[0],select[1],i3);

	or o(out,q0,q1,q2,q3);
endmodule

// 16bit 4x1 mux implementation
module mux4x1_16b(i0,i1,i2,i3,select,out);
	input [15:0] i0,i1,i2,i3; // four inputs
	input [1:0] select; // select is 2 bits, since there's 4 inputs
	output [15:0] out; // one output

	genvar i; // increment value. must be declared as genvar
	generate // must use "generate" and put our for loop inside that in order to have it at all in a module
		for(i=0; i<=15; i=i+1) begin : m_loop
			mux4x1 mux(i0[i],i1[i],i2[i],i3[i],select,out[i]); // implement 16 multiplexors with a for loop
		end // end for loop
	endgenerate // end generate block
endmodule

// 1bit 2x1 mux implementation
module mux2x1(A,B,select,out);
   input A,B,select;
   output out;
   wire n_s,a,b;
   not n (n_s,select);
   and a1 (a,n_s,A),
       a2 (b,select,B);
   or o (out,a,b);
endmodule

// 2bit 2x1 mux implementation
module mux2x1_2b(A,B,select,out);
   input [1:0] A,B;
   input select;
   output [1:0] out;
   mux2x1 mux1(A[0],B[0],select,out[0]);
   mux2x1 mux2(A[1],B[1],select,out[1]);
endmodule

// 16bit 2x12 mux implementation
module mux2x1_16b(A,B,select,out);
   input [15:0] A,B;
   input select;
   output [15:0] out;

	genvar i; // increment value. must be declared as genvar
	generate // must use "generate" and put our for loop inside that in order to have it at all in a module
		for(i=0; i<=15; i=i+1) begin : m2_loop
			mux2x1 mux(A[i],B[i],select,out[i]); // implement 16 multiplexors with a for loop
		end // end for loop
	endgenerate // end generate block
endmodule

// gate level decoder implementation
module decoder (S1,S0,D3,D2,D1,D0);
   input S0,S1;
   output D0,D1,D2,D3;

   not n1 (notS0,S0),
       n2 (notS1,S1);

   and a0 (D0,notS1,notS0),
       a1 (D1,notS1,   S0),
       a2 (D2,   S1,notS0),
       a3 (D3,   S1,   S0);
endmodule

// gate level half adder implementation
module halfadder (S,C,x,y);
   input x,y;
   output S,C;
   xor (S,x,y);
   and (C,x,y);
endmodule

// gate level full adder implementation
module fulladder (S,C,x,y,z);
   input x,y,z;
   output S,C;
   wire S1,D1,D2;

   halfadder HA1 (S1,D1,x,y),
             HA2 (S,D2,S1,z);
   or g1(C,D2,D1);
endmodule

module DataCache(Address,Write,WriteData,ReadData,Hit,Clock);
  input Write, Clock;
  input [15:0] Address;        // Memory address: 16 bits
  input [15:0] WriteData;
  output reg [15:0] ReadData;
  output reg Hit;

  reg [15:0] Memory [31:0];    // Memory: 32 16-bit words, word addressed

  reg [15:0] CacheData [7:0];  // 8 one-word blocks, 16-bit word
  reg [2:0] CacheTag [7:0];
  reg CacheValidBit [7:0];

  wire [2:0] CacheIndex;      // 3-bit cache index = Address [2:0]
  assign CacheIndex = Address[2:0];

  reg [31:0] i; // temp
  reg [4:0] X;  // no valid data

  // Clear cache
  initial
    for (i=0; i<8; i=i+1) begin
       CacheData [i] = 0;
       CacheTag [i] = 0;
       CacheValidBit[i] = 0;
    end

    initial begin
      // Load Data through cache
      // switch the cells and see how the simulation output changes
      // (beq is taken if [0]=32'h7; [1]=32'h5, not taken otherwise)
      Memory[0] = 16'h5;                    // write into memory
      Memory[1] = 16'h7;                    // write into memory
    end

   // Read
   always @(negedge Clock)
     if (Write==0) begin
       if (CacheTag[CacheIndex] == Address[15:3] & CacheValidBit[CacheIndex]==1) begin
          Hit = 1;                                  // cache hit
          ReadData = CacheData[CacheIndex];         // get the word from cache
       end
       else begin
          Hit = 0;                                  // cache miss
          CacheData[CacheIndex] = Memory[Address];  // write into cache
          CacheTag[CacheIndex] = Address[15:3];      // set up tag
          CacheValidBit[CacheIndex] = 1;            // set valid bit
          ReadData = CacheData[CacheIndex];         // read from cache
       end
     end

   // Write
   always @(negedge Clock)
     if (Write==1) begin
       if (CacheTag[CacheIndex] == Address[15:3] & CacheValidBit[CacheIndex]==1)
          Hit = 1;                                  // cache hit
       else begin
          Hit = 0;                                  // cache miss
          CacheTag[CacheIndex] = Address[15:3];      // set up tag
          CacheValidBit[CacheIndex] <= 1;            // set valid bit
        end                                          // write through
        CacheData[CacheIndex] = WriteData;          // write into cache
        Memory[Address] = WriteData;                // write into memory
     end
endmodule

// the select for the branch control unit, gate level
module BranchSelect (branchOp,zero,branchOut);
  input [1:0] branchOp;
  input zero;
  output branchOut;

  not not1(notZero,zero);
  or or1(branchOut,i0,i1);
  and and1(i0,branchOp[0],zero);
  and and2(i1,branchOp[1],notZero);
endmodule

// behavioral implementation for what controls which instruction to use
module MainControl (Op,Control);
	// resource (from lec. 8): cs.ccsu.edu/~markov/ccsu_courses/385SL8.pdf
  input [3:0] Op; // 4 bit opcode
  output reg [9:0] Control; // 11 bits

  // RegDst, AluSrc, MemToReg, RegWrite, MemWrite, Beq, Bne, AluCtrl(3bit)
  always @(Op) case (Op)
    4'b1111: Control <= 10'b0_0_0_0_0_00_000; // nop
    4'b0000: Control <= 10'b1_0_0_1_0_00_010; // add
    4'b0001: Control <= 10'b1_0_0_1_0_00_110; // sub
    4'b0010: Control <= 10'b1_0_0_1_0_00_000; // and
    4'b0011: Control <= 10'b1_0_0_1_0_00_001; // or
    4'b0111: Control <= 10'b1_0_0_1_0_00_111; // slt
    4'b0100: Control <= 10'b0_1_0_1_0_00_010; // addi
    4'b0101: Control <= 10'b0_1_1_1_0_00_010; // lw
    4'b0110: Control <= 10'b0_1_0_0_1_00_010; // sw
    4'b1000: Control <= 10'b0_0_0_0_0_01_110; // beq
    4'b1001: Control <= 10'b0_0_0_0_0_10_110; // bne
  endcase
endmodule

module CPU (clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD,Hit);

  input clock;
  output [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;
  output Hit;

  initial begin
  // Program: swap memory cells (if needed) and compute absolute value |5-7|=2
  IMemory[0]  = 16'b0101_00_01_00000000;	// lw $1, 0($0)
  IMemory[1]  = 16'b0101_00_10_00000010;	// lw $2, 2($0)
  IMemory[2]  = 16'b1111____000000000000; // nop
  IMemory[3]  = 16'b1111____000000000000; // nop
  IMemory[4]  = 16'b1111____000000000000; // nop
  IMemory[5]  = 16'b0111_01_10_11_000000;	// slt $3, $1, $2
  IMemory[6]  = 16'b1111____000000000000; // nop
  IMemory[7]  = 16'b1111____000000000000; // nop
  IMemory[8]  = 16'b1111____000000000000; // nop
  IMemory[9] = 16'b1000_11_00_00000101;		// beq $3, $0, Instruction 15
  IMemory[10] = 16'b1111____000000000000; // nop
  IMemory[11] = 16'b1111____000000000000; // nop
  IMemory[12] = 16'b1111____000000000000; // nop
  IMemory[13] = 16'b0110_00_01_00000010;	// sw $1, 2($0)
  IMemory[14] = 16'b0110_00_10_00000000;	// sw $2, 0($0)
  IMemory[15] = 16'b1111____000000000000; // nop
  IMemory[16] = 16'b1111____000000000000; // nop
  IMemory[17] = 16'b1111____000000000000; // nop
  IMemory[18] = 16'b0101_00_01_00000000;	// lw $1, 0($0)
  IMemory[19] = 16'b0101_00_10_00000010;	// lw $2, 2($0)
  IMemory[20] = 16'b1111____000000000000; // nop
  IMemory[21] = 16'b1111____000000000000; // nop
  IMemory[22] = 16'b1111____000000000000; // nop
  IMemory[23] = 16'b0001_01_10_01_000000;	// sub $1, $1, $2
  end

// Pipeline

// IF
   wire [15:0] PCplus2, NextPC;
   reg[15:0] PC, IMemory[0:1023], IFID_IR, IFID_PCplus2;
   alu fetch (3'b010,PC,16'b10,PCplus2,Unused1);

// ID
   wire [9:0] Control;
   reg [1:0] IDEX_Branch;
   reg IDEX_RegWrite,IDEX_MemtoReg,
       IDEX_MemWrite,
       IDEX_ALUSrc,  IDEX_RegDst,
       MEMWB_RegWrite;
   // reg [1:0]  IDEX_ALUOp;
   wire [15:0] RD1,RD2,SignExtend, WD;
   reg [15:0] IDEX_PCplus2,IDEX_RD1,IDEX_RD2,IDEX_SignExt,IDEXE_IR;
   reg [15:0] IDEX_IR; // For monitoring the pipeline
   reg [1:0]  IDEX_rt,IDEX_rd,MEMWB_rd;
   reg_file rf (IFID_IR[11:10],IFID_IR[9:8],MEMWB_rd,WD,MEMWB_RegWrite,RD1,RD2,clock);
   MainControl MainCtr (IFID_IR[15:12],Control);
   assign SignExtend = {{8{IFID_IR[7]}},IFID_IR[7:0]};

// EXE
   reg [1:0] EXMEM_Branch;
   reg EXMEM_RegWrite,EXMEM_MemtoReg,
       EXMEM_MemWrite;
   wire [15:0] Target;
   reg EXMEM_Zero;
   reg [15:0] EXMEM_Target,EXMEM_ALUOut,EXMEM_RD2;
   reg [15:0] EXMEM_IR; // For monitoring the pipeline
   reg [1:0] EXMEM_rd;
   wire [15:0] B,ALUOut;
   reg [2:0] ALUctl;
   wire [1:0] WR;
   wire branchSelOutput;
   alu branch (3'b010,IDEX_SignExt<<1,IDEX_PCplus2,Target,Unused2);
   alu ex (ALUctl, IDEX_RD1, B, ALUOut, Zero);
   // ALUControl ALUCtrl(IDEX_ALUOp, IDEX_SignExt[5:0], ALUctl); // ALU control unit
   // assign B  = (IDEX_ALUSrc) ? IDEX_SignExt: IDEX_RD2;        // ALUSrc Mux
   mux2x1_16b ALUSrcMux (IDEX_RD2, IDEX_SignExt, IDEX_ALUSrc, B); // ALUSrc Mux
   // assign WR = (IDEX_RegDst) ? IDEX_rd: IDEX_rt;              // RegDst Mux
   mux2x1_2b RegDstMux (IDEX_rt, IDEX_rd, IDEX_RegDst, WR);
   // assign NextPC = (EXMEM_Branch && EXMEM_Zero) ? EXMEM_Target: PCplus2;
   mux2x1_16b BranchMux (PCplus2, EXMEM_Target, branchSelOutput, NextPC); // Branch Mux
   BranchSelect branchSel (EXMEM_Branch, EXMEM_Zero, branchSelOutput);

// MEM
   reg MEMWB_MemtoReg;
   reg [15:0] DMemory[0:1023],MEMWB_MemOut,MEMWB_ALUOut;
   reg [15:0] MEMWB_IR; // For monitoring the pipeline
   wire [15:0] MemOut;
   // assign MemOut = DMemory[EXMEM_ALUOut>>1];
   // always @(negedge clock) if (EXMEM_MemWrite) DMemory[EXMEM_ALUOut>>1] <= EXMEM_RD2;
   // clock pulse switched, because reading data is delayed by one cycle
   DataCache cache(EXMEM_ALUOut>>1,EXMEM_MemWrite,EXMEM_RD2,MemOut,Hit,~clock);

// WB
   // assign WD = (MEMWB_MemtoReg) ? MEMWB_MemOut: MEMWB_ALUOut;
   mux2x1_16b WDmux (MEMWB_ALUOut, MEMWB_MemOut, MEMWB_MemtoReg, WD); // MemtoReg Mux


   initial begin
    PC = 0;
// Initialize pipeline registers
    IDEX_RegWrite=0;IDEX_MemtoReg=0;IDEX_Branch=0;IDEX_MemWrite=0;IDEX_ALUSrc=0;IDEX_RegDst=0;
    IFID_IR=0;
    EXMEM_RegWrite=0;EXMEM_MemtoReg=0;EXMEM_Branch=0;EXMEM_MemWrite=0;
    EXMEM_Target=0;
    MEMWB_RegWrite=0;MEMWB_MemtoReg=0;
   end

// Running the pipeline

   always @(negedge clock) begin

// IF
    PC <= NextPC;
    IFID_PCplus2 <= PCplus2;
    IFID_IR <= IMemory[PC>>1];

// ID
    IDEX_IR <= IFID_IR; // For monitoring the pipeline
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch,ALUctl} <= Control;
    IDEX_PCplus2 <= IFID_PCplus2;
    IDEX_RD1 <= RD1;
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[9:8];
    IDEX_rd <= IFID_IR[7:6];

// EXE
    EXMEM_IR <= IDEX_IR; // For monitoring the pipeline
    EXMEM_RegWrite <= IDEX_RegWrite;
    EXMEM_MemtoReg <= IDEX_MemtoReg;
    EXMEM_Branch   <= IDEX_Branch;
    EXMEM_MemWrite <= IDEX_MemWrite;
    EXMEM_Target <= Target;
    EXMEM_Zero <= Zero;
    EXMEM_ALUOut <= ALUOut;
    EXMEM_RD2 <= IDEX_RD2;
    EXMEM_rd <= WR;

// MEM
    MEMWB_IR <= EXMEM_IR; // For monitoring the pipeline
    MEMWB_RegWrite <= EXMEM_RegWrite;
    MEMWB_MemtoReg <= EXMEM_MemtoReg;
    MEMWB_MemOut <= MemOut;
    MEMWB_ALUOut <= EXMEM_ALUOut;
    MEMWB_rd <= EXMEM_rd;

// WB
// Register write happens on neg edge of the clock (if MEMWB_RegWrite is asserted)

  end

endmodule


// Test module

module test ();

  reg clock;
  wire [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;
  wire Hit; // 1B value to determine if hit/miss

  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD,Hit);

  always #1 clock = ~clock;

  initial begin
    $display ("time PC  H  IFID_IR\t\tIDEX_IR\t\tEXMEM_IR\tMEMWB_IR\tWD");
    $monitor ("%2d  %3d  %3d  %b %b %b %b %h", $time,PC,Hit,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
    clock = 1;
    #56 $finish;
  end

endmodule


/* Compiling and simulation

C:\Markov\CCSU Stuff\Courses\Spring-10\CS385\HDL>iverilog mips-pipe.vl

C:\Markov\CCSU Stuff\Courses\Spring-10\CS385\HDL>vvp a.out

time PC  IFID_IR  IDEX_IR  EXMEM_IR MEMWB_IR WD
 0    0  00000000 xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
 1    4  8c080000 00000000 xxxxxxxx xxxxxxxx xxxxxxxx
 3    8  8c090004 8c080000 00000000 xxxxxxxx xxxxxxxx
 5   12  00000000 8c090004 8c080000 00000000 00000000
 7   16  00000000 00000000 8c090004 8c080000 00000005
 9   20  00000000 00000000 00000000 8c090004 00000007
11   24  0109502a 00000000 00000000 00000000 00000000
13   28  00000000 0109502a 00000000 00000000 00000000
15   32  00000000 00000000 0109502a 00000000 00000000
17   36  00000000 00000000 00000000 0109502a 00000001
19   40  11400005 00000000 00000000 00000000 00000000
21   44  00000000 11400005 00000000 00000000 00000000
23   48  00000000 00000000 11400005 00000000 00000000
25   52  00000000 00000000 00000000 11400005 00000001
27   56  ac080004 00000000 00000000 00000000 00000000
29   60  ac090000 ac080004 00000000 00000000 00000000
31   64  00000000 ac090000 ac080004 00000000 00000000
33   68  00000000 00000000 ac090000 ac080004 00000004
35   72  00000000 00000000 00000000 ac090000 00000000
37   76  8c0b0000 00000000 00000000 00000000 00000000
39   80  8c0c0004 8c0b0000 00000000 00000000 00000000
41   84  00000000 8c0c0004 8c0b0000 00000000 00000000
43   88  00000000 00000000 8c0c0004 8c0b0000 00000007
45   92  00000000 00000000 00000000 8c0c0004 00000005
47   96  016c5822 00000000 00000000 00000000 00000000
49  100  xxxxxxxx 016c5822 00000000 00000000 00000000
51  104  xxxxxxxx xxxxxxxx 016c5822 00000000 00000000
53  108  xxxxxxxx xxxxxxxx xxxxxxxx 016c5822 00000002
55  112  xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx 0000000X

*/
