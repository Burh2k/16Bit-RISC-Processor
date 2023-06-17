module BranchControl (BranchOp,Zero,BranchOut);

  input [1:0] BranchOp; // two bits to handle bne/beq
  input Zero;
  output BranchOut;
  wire ZeroInvert,i0,i1;

  not not1(ZeroInvert,Zero);
  and and1(i0,BranchOp[0],Zero);
  and and2(i1,BranchOp[1],ZeroInvert);
  or or1(BranchOut,i0,i1);
endmodule