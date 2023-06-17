//********** CPU **********
// CPU template modified from "mips-pipe3.vl"
module CPU (clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  input clock;
  output [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;
 reg  [15:0] PC, IMemory[0:1023], IFID_IR,IFID_PCplus2;
   reg [15:0] DMemory[0:1023],MEMWB_MemOut,MEMWB_ALUOut;
  initial begin 
      //                            //from template   //changed to work with our 4 regs //instruction format
   
    IMemory[0] = 16'b0001000100100000;  // lw $8, 0($0)      -> lw $1, 0($0)   0101 00 01 00000000
    IMemory[1] = 16'b0010000110010010;  // lw $9, 4($0)      -> lw $2, 2($0)   0101 00 10 00000010
    IMemory[2] = 16'b0011001010011100;  // nop
    IMemory[3] = 16'b0000000000000000;  // nop
    IMemory[4] = 16'b0000100111000000;  // nop
	IMemory[5] = 16'b0000000000000000;  // slt $10, $9, $8  -> slt $3, $2, $1 0111 10 01 11 000000
	IMemory[6] = 16'b0100001101011001;  // nop
	IMemory[7] = 16'b0000000000000000;  // nop
	IMemory[8] = 16'b0000100111000000; // nop
	IMemory[9] = 16'b0000000000000000;  // bne$10, $0, 28    -> bne $3, $0, 14 1001 11 00 00000100
	IMemory[10] = 16'b0000000000000000;  // nop
	IMemory[11] = 16'b0100001101011001;  // nop
	IMemory[12] = 16'b0000000000000000;  // nop 
	IMemory[13] = 16'b0001011001000000;  // sub $11, $11, $12 -> sub $1, $1, $2 0001 01 10 01 000000
	IMemory[14] = 16'b0000000000000000;  // nop
	IMemory[15] = 16'b0100001101011001;  // nop
	IMemory[16] = 16'b0110010101011010;  // nop 
	IMemory[17] = 16'b0000100111000000;  // add $10, $12, $11 -> add $3, $2, $1 0000 10 01 11 000000 // should be branch target
   
    // Data
    DMemory [0] = 16'h5; // switch the cells and see how the simulation output changes
    DMemory [1] = 16'h7;
  end

  // Pipeline stages

  //IF 
  wire [15:0] NextPC,PCplus2;
 
  reg [1:0] EXMEM_Branch;
  reg MEMWB_RegWrite,MEMWB_MemtoReg;
  reg [15:0] EXMEM_Target,EXMEM_ALUOut,EXMEM_RD2;
  reg EXMEM_Zero;
  reg [1:0] MEMWB_rd;	 
  ALU fetch (3'b010,PC,2,PCplus2,Unused); //play with timings here
  BranchControl BranchCtrl (EXMEM_Branch,EXMEM_Zero,BranchConOut); // added branch control
  mux2x1_16bit BranchMux (PCplus2,EXMEM_Target,BranchConOut,NextPC); // added mux for branch
  
  //ID
  reg  [15:0] IDEX_IR; // For monitoring the pipeline
  wire [9:0] Control;
  reg IDEX_RegWrite,IDEX_ALUSrc,IDEX_RegDst,IDEX_MemtoReg,IDEX_MemWrite;
  reg  [1:0] IDEX_Branch; // because our bne and bqe are 2 bits
  reg  [2:0] IDEX_ALUOp;  // our aluOps are 3 bits
  wire [15:0] RD1,RD2,SignExtend, WD;
  reg  [15:0] IDEX_RD1,IDEX_RD2,IDEX_SignExt,IDEX_PCplus2,IDEXE_IR; // added IDEX_PCplus2,IDEXE_IR
  reg  [1:0]  IDEX_rt,IDEX_rd; //should be 2 bit
  reg_file rf (IFID_IR[11:10],IFID_IR[9:8],MEMWB_rd,WD,MEMWB_RegWrite,RD1,RD2,clock); // added MEMWB_rd & MEMWB_RegWrite
  MainControl MainCtr (IFID_IR[15:12],Control); 
  assign SignExtend = {{8{IFID_IR[7]}},IFID_IR[7:0]}; 
  
  //EXE
  reg EXMEM_RegWrite,EXMEM_MemtoReg,EXMEM_MemWrite;
  wire [15:0] Target;


  reg [15:0] EXMEM_IR; // this is for monitoring the pipeline
  reg [1:0] EXMEM_rd;
  wire [15:0] B,ALUOut;
  wire [1:0] WR;
  ALU branch (3'b010,IDEX_SignExt<<1,IDEX_PCplus2,Target,Unused2);
  ALU ex (IDEX_ALUOp, IDEX_RD1, B, ALUOut, Zero); 
  mux2bit2x1 RegDstMux (IDEX_rt, IDEX_rd, IDEX_RegDst, WR); // assign WR, Reg Dst mux 
  mux2x1_16bit ALUSrcMux (IDEX_RD2, IDEX_SignExt, IDEX_ALUSrc, B); // assign B, ALU src mux       
  
  
  //MEM


  reg [15:0] MEMWB_IR; // For monitoring the pipeline
  wire [15:0] MemOut;

  assign MemOut = DMemory[EXMEM_ALUOut>>1];
  always @(negedge clock) if (EXMEM_MemWrite) DMemory[EXMEM_ALUOut>>1] <= EXMEM_RD2;
  
  //WB <--- this area is what I believe is causing trouble
  //assign WD = ALUOut; //WD simply gets ALU output, FROM PR3
  //assign WD = (MEMWB_MemtoReg) ? MEMWB_MemOut: MEMWB_ALUOut; // MemtoReg Mux, FROM PR4 TEMPLATE
  mux2x1_16bit MemToReg (MEMWB_ALUOut, MEMWB_MemOut, MEMWB_MemtoReg, WD);

  initial begin
    PC = 0;
	// Initialize pipeline registers
    IDEX_RegWrite=0;IDEX_MemtoReg=0;IDEX_Branch=0;IDEX_MemWrite=0;IDEX_ALUSrc=0;IDEX_RegDst=0;IDEX_ALUOp=0;
    IFID_IR=0;
    EXMEM_RegWrite=0;EXMEM_MemtoReg=0;EXMEM_Branch=0;EXMEM_MemWrite=0;
    EXMEM_Target=0;
    MEMWB_RegWrite=0;
	 MEMWB_MemtoReg=0;
  end

  //RUNNING THE PIPELINE

  always @(negedge clock) begin 

    //STAGE 1 - IF
    PC <= NextPC;
	IFID_PCplus2 <= PCplus2;
    IFID_IR <= IMemory[PC>>1];

    //STAGE 2 - ID
    IDEX_IR <= IFID_IR; // For monitoring the pipeline
	// RegDst[1], AluSrc[1], MemtoReg[1], RegWrite[1], MemWrite1[1], BEQ[1], BNE[1], AluCtrl[3]
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch,IDEX_ALUOp} <= Control; 
    IDEX_PCplus2 <= IFID_PCplus2;	
    IDEX_RD1 <= RD1; 
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[9:8];
    IDEX_rd <= IFID_IR[7:6];

    //STAGE 3 - EX
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
	
	//STAGE 4 - MEM
	MEMWB_IR <= EXMEM_IR; // For monitoring the pipeline
    MEMWB_RegWrite <= EXMEM_RegWrite;
    MEMWB_MemtoReg <= EXMEM_MemtoReg;
    MEMWB_MemOut <= MemOut;
    MEMWB_ALUOut <= EXMEM_ALUOut;
    MEMWB_rd <= EXMEM_rd;
	
	//STAGE 5 - WB
	// Register write happens on neg edge of the clock (if MEMWB_RegWrite is asserted)

  end
endmodule

//********** END OF CPU MODULE **********
