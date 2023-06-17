//used by WR
module mux2bit2x1(A,B,select,OUT);
	input [1:0] A,B;
    input select;
	output [1:0] OUT;
	//cascade 2 2x1 muxs
    mux2x1 mux1(A[0], B[0], select, OUT[0]),
           mux2(A[1], B[1], select, OUT[1]);
endmodule