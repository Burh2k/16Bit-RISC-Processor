module flipFlop16(D,CLK,Q);
  input [15:0] D; // change input and outputs to 16 bits
  input CLK;      // clock pulse
  output [15:0] Q;
  
  //cascade single bit dflipflops
  D_flip_flop  f0(D[0], CLK,  Q[0]),
               f1(D[1], CLK,  Q[1]),
               f2(D[2], CLK,  Q[2]),
               f3(D[3], CLK,  Q[3]),
               f4(D[4], CLK,  Q[4]),
               f5(D[5], CLK,  Q[5]),
               f6(D[6], CLK,  Q[6]),
               f7(D[7], CLK,  Q[7]),
               f8(D[8], CLK,  Q[8]),
               f9(D[9], CLK,  Q[9]),
             f10(D[10], CLK, Q[10]),
             f11(D[11], CLK, Q[11]),
             f12(D[12], CLK, Q[12]),
             f13(D[13], CLK, Q[13]),
             f14(D[14], CLK, Q[14]),
             f15(D[15], CLK, Q[15]); 
endmodule