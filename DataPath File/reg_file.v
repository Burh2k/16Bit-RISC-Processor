// modified register file to use 16 bits
module reg_file (rr1,rr2,wr,wd,regwrite,rd1,rd2,clock);

   input  [1:0] rr1,rr2,wr;
   input  [15:0] wd; // change to 16 bit
   input regwrite,clock;
   output [15:0] rd1,rd2; // change to 16 bit
   wire   [15:0] q0,q1,q2,q3; // change mux wires to 16 bit
// registers
   //16 bit flip flops here
   flipFlop16  r0 (16'b0,c0,q0); //$0 register should be 0
   flipFlop16  r1 (wd,c1,q1);
   flipFlop16  r2 (wd,c2,q2);
   flipFlop16  r3 (wd,c3,q3);

// output port

   mux16bit mux1 (0,q1,q2,q3,rr1,rd1), //16 bit mux here
            mux2 (0,q1,q2,q3,rr2,rd2);

// input port

   decoder dec(wr[1],wr[0],w3,w2,w1,w0);

   and a (regwrite_and_clock,regwrite,clock);

   and a1 (c1,regwrite_and_clock,w1),
       a2 (c2,regwrite_and_clock,w2),
       a3 (c3,regwrite_and_clock,w3);
endmodule
