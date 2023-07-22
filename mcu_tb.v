`timescale 1ns/1ps



module mcu_tb ();
  
 localparam op_sz = 32, mem_sz = 8  , clk_period = 10 ;
 
reg clk =0 ;
reg reset;
reg [mem_sz-1 : 0] op0;
reg [op_sz-1 : 0] op1;
reg [mem_sz-1 : 0] op2;
reg [3:0] op;
wire [op_sz-1 : 0] out;
wire op_err ;
wire op_done;

  
  localparam add =0 , sub= 1, 
             multip =2,divide =3,
             OR=4 , AND=5, 
             XOR =6, read =7 ,write =8;
         localparam lift =9 , right =10 ,arth =11;


  mcu #(op_sz ,mem_sz ) mcu_dut (clk,reset,op0,op1,op2,
  op,out,op_err,op_done);
  
  always #(clk_period/2) clk= ~clk;
 
 
 // task to write into location 
  task write_task ( input reg [op_sz-1 : 0] data,
         input reg [mem_sz-1 : 0] addr
  );  begin
    op0 = addr;
    op1 = data ;
    op=8;
   #clk_period ;
   
  end
endtask 

//task to read 
task read_task (input reg [mem_sz-1 : 0] addr
 );
begin 
op0 = addr;
 op=7; 
  #clk_period ;
end

endtask


// operation task
  task comb_task ( input reg [mem_sz-1 : 0] addr_1,
            input reg [op_sz-1 : 0] addr_2,
            input reg [3 : 0] opp_code,
            input reg [mem_sz-1 : 0] out_addr
            
   ); begin
     if (opp_code==8)
       write_task  (addr_2,addr_1);
      else if(opp_code==2 || opp_code==8|| opp_code==9|| opp_code==10  )
      sq_task (addr_1,addr_2,opp_code,out_addr);
     else 
      begin
        op0 =addr_1 ;
        op1= addr_2 ;
        op=opp_code ;
        op2 =out_addr;
        #clk_period ;
           
      end
    
   
    
  end
  endtask
    
    task sq_task ( input reg [mem_sz-1 : 0] addr_1,
            input reg [op_sz-1 : 0] addr_2,
            input reg [3 : 0] opp_code,
            input reg [mem_sz-1 : 0] out_addr
   ); begin
     if (opp_code==8)
       write_task  (addr_2,addr_1);
     else 
      begin
        reset =1;
        op0 =addr_1 ;
        op1= addr_2 ;
        op=opp_code ;
        op2 =out_addr;
         #(clk_period);
         reset =0;  
        #(clk_period);
        wait(op_done)
          #(clk_period)
           reset =1;
            #(clk_period);
            reset =0;
           
      end    
      
        
  end
  endtask
      

// check function

reg [op_sz-1 : 0] out_f ;
 reg op_err_f;
function  reg check(

input reg [mem_sz-1 : 0] in_1,
            input reg [op_sz-1 : 0] in_2,
            input reg [3 : 0] opp_code
);begin


 
case(opp_code)
    add: out_f = in_1 +in_2;
    sub: out_f = in_1 - in_2;
    multip :out_f=in_1 *in_2;
    divide : out_f = in_1/in_2 ;
    OR :   out_f = in_1 | in_2 ;
    AND :  out_f = in_1 & in_2 ;
    XOR : out_f = in_1 ^ in_2 ;
    read :  
       out_f = in_1 ;
    write :
       out_f = in_1 ;
    lift :  out_f = in_1 << in_2;
    right:out_f = in_1 >> in_2;
    arth:out_f = in_1 >>> in_2;
    default :op_err_f =1;
 endcase  
if(op<11)begin
  if (out_f==out) 
  begin
$display("check_correct , @%t, out= %d, function_out %d,op %d",$time,out,out_f,opp_code );
end
else begin $display("check_wrong, @%t, out= %d, function_out %d,op %d",$time,out,out_f,opp_code ); 
end
end

else begin  
  if(op_err_f== op_err)
$display("check_correct, wrong op code @%t",$time);
else 
  $display("check_wrong, wrong op code @%t",$time);
end
 end
endfunction





    


  reg check_f ;
  
  
  initial begin
  
   reset =1;
           #(clk_period);
           reset =0;  
  /*
  first writing 4 values 
       to use for test  
  */ 
     write_task  (12,5);// writing 12
     write_task  (15,6); //witing 15
     write_task (65,0);//writing 65
     write_task (3,1);//writing 3
     comb_task (5,6,0,12);// add 12 +15 =27 store in 12     
     read_task (12);
     
     check_f =check (12,15,0);
     comb_task (6,5,1,11);// sub 15 -12 =3 
      read_task (11);
      check_f =check (15,12,1);
     comb_task (5,1,3,9);// 12/3 =4
       read_task (9);
       check_f =check (12,3,3);
      comb_task (6,1,4,13);// 15oring3 =15
       read_task (13);
       check_f =check (15,3,4);
      comb_task (6,1,5,9);// 15and3 
       read_task (9);
       check_f =check (15,3,5);
     comb_task (5,12,6,8);//xoring 12 ,27 = 23
       read_task (8);
       check_f =check (12,27,6);
     sq_task (5,1,9,14);// 12shift lift by 3
     read_task(14);
     #(clk_period);
     check_f =check (12,3,9);
     sq_task (6,1,10,15);// 15shift right by 3
     read_task(15);
     #(clk_period);
     check_f =check (15,3,10);
     sq_task (1,0,2,10);//  65*3 =195
     read_task (10);
     #(clk_period);
     check_f =check (65,3,2);
     comb_task (5,12,14,8);//wrong op code
     check_f =check (65,3,14);      
  
 
  
  
  
end  
  

 endmodule 
  