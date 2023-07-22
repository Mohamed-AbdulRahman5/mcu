




module sq_mult#(parameter op_sz=32) (
  input clk ,reset ,
  input  [op_sz-1:0] mult0, mult1,
  input[3:0] op,
  output reg [op_sz-1:0] out ,
  output reg op_done 
);



localparam  fitch =0 ,opr =1 , stop =2 ;


 reg [1:0] state, next_state ;
 reg [op_sz-1:0] out_next ;
 reg [op_sz-1:0] mult0_shift, mult1_shift ;
 reg [op_sz-1:0] mult0_shift_next, mult1_shift_next ;
 
 

always@(posedge clk) begin
        if(reset)
        begin
         out <= 0; 
         state <=fitch; 
         mult0_shift<=0 ;   
         mult1_shift<=0 ;  
        end
        else begin
        out <= out_next ;
        state <= next_state ;
        mult0_shift<=mult0_shift_next ;   
        mult1_shift<=mult1_shift_next ;  
        end
          end    
      






    always @(*) begin
      out_next=0;
      op_done=0;
      mult0_shift_next=0;
      mult1_shift_next=0;
      next_state =fitch ;
      case(state)
      fitch : begin
        out_next =0;
        op_done =0;
         if(mult0>mult1) //optimization 
           begin
             mult0_shift_next=mult0;
             mult1_shift_next= mult1;
           end
         else begin
            mult0_shift_next=mult1;
             mult1_shift_next= mult0;
         end
         if(op==2)
          next_state = opr ;
        else next_state =fitch ;
       end
     opr : begin 
           mult0_shift_next = mult0_shift <<1;
           mult1_shift_next = mult1_shift >>1;
           if(mult1_shift[0]==1)
           out_next = mult0_shift + out ;
         else out_next = out ;
          if(mult1_shift)
            next_state = opr ;
          else begin next_state = stop ;
          op_done =1;
           end
           
       
     end
     stop:  begin op_done =0;
        out_next = out;
        next_state = fitch ; end
      
      
      
      
      
   endcase 
    end




endmodule 