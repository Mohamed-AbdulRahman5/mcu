module shift_tb ();
  
  parameter op_sz=32,clk_period = 10 ;

  reg clk=0 ;
                  reg en;
                  reg[3:0] op;
                  reg reset ;
                  reg [op_sz-1:0] data;
                  reg [$clog2(op_sz)-1:0] shift_value ;
                  wire [op_sz-1:0] out ;
                  wire op_done;    
localparam lift =8 , right =9 ,arth =10;
     
      sq_shift#( op_sz) dut
                 ( clk , en, op,reset , data,shift_value ,out ,op_done);
                 
                 
                 always #(clk_period/2) clk= ~clk;
                 
                 
               initial begin
               reset =1;
               #(clk_period);
               reset =0;               
               en= 1;
               op =lift;
               data = 32'b0000_0000_0101_0000_0110_0001_1011_0010;
               shift_value =5'b01001;//shift by9
               wait(op_done)
               #(clk_period);
                reset =1;
                 op =right;
                data = 18;
                shift_value =3;
               #(clk_period);
               reset =0; 
               wait(op_done)             
              #(clk_period);
                reset =1;
                 op =arth;
                data = 32'b1000_0000_0101_0000_0110_0001_1011_0010;
                shift_value =6;
               #(clk_period);
               reset =0;
               
               
               
               
             end  
       endmodule        