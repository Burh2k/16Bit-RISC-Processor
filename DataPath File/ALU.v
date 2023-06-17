//********** ALU MODULES **********
// 16-bit MIPS ALU in Verilog using modified template of 4-bit ALU
module ALU (op,a,b,result,zero);
   input  [15:0] a; //16 bit inputs a,b
   input  [15:0] b;
   input  [2:0] op; //3 bit alu opp code
   output [15:0] result; // produce 16 bit output
   output zero;
   wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16;
   
   //cascade 16 single bit alu's	
   ALU1   alu0  (a[0], b[0], op[2], op[1:0],set,op[2],c1,result[0]);
   ALU1   alu1  (a[1], b[1], op[2], op[1:0],0,  c1,   c2,result[1]);
   ALU1   alu2  (a[2], b[2], op[2], op[1:0],0,  c2,   c3,result[2]);
   ALU1   alu3  (a[3], b[3], op[2], op[1:0],0,  c3,   c4,result[3]);
   ALU1   alu4  (a[4], b[4], op[2], op[1:0],0,  c4,   c5,result[4]);
   ALU1   alu5  (a[5], b[5], op[2], op[1:0],0,  c5,   c6,result[5]);
   ALU1   alu6  (a[6], b[6], op[2], op[1:0],0,  c6,   c7,result[6]);
   ALU1   alu7  (a[7], b[7], op[2], op[1:0],0,  c7,   c8,result[7]);
   ALU1   alu8  (a[8], b[8], op[2], op[1:0],0,  c8,   c9,result[8]);
   ALU1   alu9  (a[9], b[9], op[2], op[1:0],0,  c9,  c10,result[9]);
   ALU1   alu10 (a[10],b[10],op[2], op[1:0],0, c10,  c11,result[10]);
   ALU1   alu11 (a[11],b[11],op[2], op[1:0],0, c11,  c12,result[11]);
   ALU1   alu12 (a[12],b[12],op[2], op[1:0],0, c12,  c13,result[12]);
   ALU1   alu13 (a[13],b[13],op[2], op[1:0],0, c13,  c14,result[13]);
   ALU1   alu14 (a[14],b[14],op[2], op[1:0],0, c14,  c15,result[14]);
   ALUmsb alu15 (a[15],b[15],op[2], op[1:0],0, c15,  c16,result[15],set);

   or or1(or01, result[0],result[1]);
   or or2(or23, result[2],result[3]);
   nor nor1(zero,or01,or23);
endmodule