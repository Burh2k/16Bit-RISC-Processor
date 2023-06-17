//********** REGFILE MODULES **********
module mux16bit(i0, i1, i2, i3, select, O);
  input  [15:0] i0, i1, i2, i3; //change inputs to 16 bit
  input  [1:0] select; //select kept 2 bits
  output [15:0] O; //output changed to 16 bits
  
  // cascade 4x1 mux's from template
  mux4x1 mux0(i0[0],  i1[0],  i2[0],  i3[0], select,  O[0]),
         mux1(i0[1],  i1[1],  i2[1],  i3[1], select,  O[1]),
         mux2(i0[2],  i1[2],  i2[2],  i3[2], select,  O[2]),
         mux3(i0[3],  i1[3],  i2[3],  i3[3], select,  O[3]),
         mux4(i0[4],  i1[4],  i2[4],  i3[4], select,  O[4]),
         mux5(i0[5],  i1[5],  i2[5],  i3[5], select,  O[5]),
         mux6(i0[6],  i1[6],  i2[6],  i3[6], select,  O[6]),
         mux7(i0[7],  i1[7],  i2[7],  i3[7], select,  O[7]),
         mux8(i0[8],  i1[8],  i2[8],  i3[8], select,  O[8]),
         mux9(i0[9],  i1[9],  i2[9],  i3[9], select,  O[9]),
       mux10(i0[10], i1[10], i2[10], i3[10], select, O[10]),
       mux11(i0[11], i1[11], i2[11], i3[11], select, O[11]),
       mux12(i0[12], i1[12], i2[12], i3[12], select, O[12]),
       mux13(i0[13], i1[13], i2[13], i3[13], select, O[13]),
       mux14(i0[14], i1[14], i2[14], i3[14], select, O[14]),
       mux15(i0[15], i1[15], i2[15], i3[15], select, O[15]);
endmodule