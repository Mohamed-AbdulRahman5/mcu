module sq_mult_tb ();

parameter op_sz=32,clk_period = 10 ;
 reg clk=0 ;
 reg reset ;
  reg  [op_sz-1:0] mult0, mult1;
  reg[3:0] op;
  wire [op_sz-1:0] out ;
  wire op_done ;


sq_mult#(op_sz)dut (
 clk ,reset , mult0, mult1, op,out ,op_done 
);


always #(clk_period/2) clk= ~clk;



initial begin
               reset =1;
               #(clk_period);
               reset =0;
               op =2 ;
               mult0= 5;
               mult1=4;
               wait(op_done)
               #(clk_period);
                reset =1;
                 mult0= 5;
               mult1=9;
               #(clk_period);
               reset =0; 
               wait(op_done)
               #(clk_period);
                reset =1;
                 mult0= 7;
               mult1=600;
               #(clk_period);
               reset =0; 
               wait(op_done)
               #(clk_period);
                reset =1;
                 mult0= 420;
               mult1=600;
               #(clk_period);
               reset =0; 
             end
               

















endmodule 
