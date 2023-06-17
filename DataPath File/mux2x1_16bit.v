//used by WD, B, Branch
module mux2x1_16bit(A, B, select, OUT);
	input [15:0] A,B;
    input select;
	output [15:0] OUT;
	//cascade 16 2x1 mux's
    mux2x1 mux1(A[0],   B[0],  select, OUT[0]),
           mux2(A[1],   B[1],  select, OUT[1]),
           mux3(A[2],   B[2],  select, OUT[2]),
           mux4(A[3],   B[3],  select, OUT[3]),
           mux5(A[4],   B[4],  select, OUT[4]),
           mux6(A[5],   B[5],  select, OUT[5]),
           mux7(A[6],   B[6],  select, OUT[6]),
           mux8(A[7],   B[7],  select, OUT[7]),
           mux9(A[8],   B[8],  select, OUT[8]),
           mux10(A[9],  B[9],  select, OUT[9]),
           mux11(A[10], B[10], select, OUT[10]),
           mux12(A[11], B[11], select, OUT[11]),
           mux13(A[12], B[12], select, OUT[12]),
           mux14(A[13], B[13], select, OUT[13]),
           mux15(A[14], B[14], select, OUT[14]),
           mux16(A[15], B[15], select, OUT[15]);
endmodule