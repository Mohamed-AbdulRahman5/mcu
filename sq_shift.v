  
  
  
 module sq_shift#(parameter op_sz=32)
                 (input clk ,
                  input en,
                  input[3:0] op,
                  input reset ,
                  input [op_sz-1:0] data,
                  input [$clog2(op_sz)-1:0] shift_value ,
                  output reg [op_sz-1:0] out ,
                  output reg op_done                     
                 
                 );
                 
        localparam  fitch =0 ,shift =1 , stop =2 , mult=3;//gray code
                 
         localparam lift =9 , right =10 ,arth =11;
         
         reg [$clog2(op_sz)-1:0] shift_count,count_next  ;
         reg [op_sz-1:0] out_next ;
         reg [1:0] state, next_state ;

         
        always@(posedge clk) begin
        if(reset)
        begin
         shift_count <=0;
         out <= 0;  
         state <= fitch; 
      
        end
        else begin
        out <= out_next ;
        state <= next_state ;
         shift_count <=count_next;
        end
          end    

always@(*)
begin
op_done = 0;
out_next =0;
next_state = fitch ;
 count_next = 0;
case(state) 
fitch: begin 
      if(en) begin
      next_state = shift ; 
      out_next= data ;
      count_next = shift_value; end
      else begin
     op_done = 0;
     count_next = 0;
     next_state = fitch ;
      end
      end
shift:
    begin
     if (shift_count==0) begin
         next_state = stop; 
         out_next = out;
         op_done =1;
     end
      else begin
        case(op)
               lift:  out_next = out <<1;
               right: out_next = out >>1;
               arth: out_next = out >>>1; 
               default: out_next= out;
                                     
            endcase   
           count_next = shift_count -1 ;
            next_state = shift ; 
    
      end 
      end
    stop: begin
        op_done =0;
        out_next = 0;
        next_state = fitch ;
        count_next = 0;
    
    end
    
 

endcase
end







endmodule