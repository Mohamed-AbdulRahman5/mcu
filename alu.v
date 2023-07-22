 
 
 
 
 
 module alu #( parameter op_sz=32)(
 input clk ,reset,
 input [3:0] op,
 input [op_sz-1:0] in_1,//from input
 input [op_sz-1:0] in_2,//from memory
 output reg [op_sz-1:0] out,
 output reg op_err,
 output reg  op_done
 );

  localparam add =0 , sub= 1, 
             multip =2,divide =3,
             OR=4 , AND=5, 
             XOR =6, read =7,write =8; 
             localparam lift =9 , right =10 ,arth =11;
             
      wire[op_sz-1:0] mult_out ;
      wire mult_done;          
sq_mult#(.op_sz(op_sz)) multp (
              .clk(clk) ,.reset(reset) , .mult0(in_1), .mult1(in_2),
               .op(op),.out(mult_out) ,.op_done(mult_done) 
             );
             
       wire [op_sz-1:0]shift_out ;
       wire shift_done;  
       reg shift_en;     
  sq_shift#( .op_sz(op_sz)) shift
                  ( .clk(clk) , .en(shift_en), .op(op),.reset(reset) ,
                   .data(in_1),.shift_value(in_2) ,.out(shift_out) ,.op_done(shift_done));
             
 always @(*)
 
 begin  
 out = 0;
  op_err = 0 ;
  shift_en=0;
  op_done =1;
   case(op)
    add: out = in_1 +in_2;
    sub: out = in_1 - in_2;
    multip :begin out = mult_out ;
            op_done =mult_done;
            end
    divide : out = in_1/in_2 ;
    OR :    out = in_1 | in_2 ;
    AND :  out = in_1 & in_2 ;
    XOR : out = in_1 ^ in_2 ;
    read : begin  
       out = in_1 ;
    end
    write : begin
       out = in_1 ;
    end
    lift : begin 
         shift_en=1;
         out = shift_out ;
         op_done =shift_done;
    end
    right:begin
             shift_en=1;
             out = shift_out ;
             op_done =shift_done;
     end
    arth:begin 
             shift_en=1;
             out = shift_out ;
             op_done =shift_done;
    end
    
    default : begin     
        op_err = 1 ;
    end 
    
 endcase  

 
 end



 
 
   
   
 endmodule
