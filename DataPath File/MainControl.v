//********** CONTROL MODULES **********
module MainControl (Op, Control);
    input [3:0] Op;
	// RegDst[1], AluSrc[1], MemtoReg[1], RegWrite[1], MemWrite1[1], BEQ[1], BNE[1], AluCtrl[3]
    output reg [9:0] Control; // 10 bits from ^^^

    always @(Op) case (Op)
    4'b0000: Control <= 10'b1001000010; //add
    4'b0001: Control <= 10'b1001000110; //sub
    4'b0010: Control <= 10'b1001000000; //and
    4'b0011: Control <= 10'b1001000001; //or
    4'b0111: Control <= 10'b1001000111; //slt
    4'b0101: Control <= 10'b0111000010; //lw
    4'b0110: Control <= 10'b0100100010; //sw
    4'b1000: Control <= 10'b0000001110; //beq
    4'b1001: Control <= 10'b0000010110; //bne
    4'b0100: Control <= 10'b0101000010; //addi
    endcase
endmodule