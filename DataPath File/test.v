//********** TEST MODULE **********
module test ();

  reg clock;
  wire [15:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD; 

  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  always #1 clock = ~clock;
  
  initial begin
    $display ("time PC  IFID_IR  IDEX_IR  EXMEM_IR MEMWB_IR WD");
    $monitor ("%2d  %3d  %h     %h     %h    %h     %h", $time,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
    clock = 1;
    #1000;  //this number will have to be changed for the # of new instructions

  end
endmodule