
module mcu #(
parameter op_sz = 32,
parameter mem_sz = 8
) (
input wire clk,reset,
input wire [mem_sz-1 : 0] op0,
input wire [op_sz-1 : 0] op1,
input wire [mem_sz-1 : 0] op2,
input wire [3:0] op,
output wire [op_sz-1 : 0] out,
output wire op_err,
 output wire op_done
);

reg we;
wire [op_sz-1:0] alu_in_1,alu_in_2,alu_out;
reg [op_sz-1:0] data_w;
reg [mem_sz-1 : 0] wr_addr ;
reg    [op_sz-1 : 0] out_reg,out_next ;



// op code 
localparam add =0 , sub= 1, 
             multip =2,divide =3,
             OR=4 , AND=5, 
             XOR =6, read =7 ,write =8;
             localparam lift =9 , right =10 ,arth =11;
 
memory #(.Addr_width(mem_sz) , .data_width(op_sz))mem(
         .clk(clk),
         .we(we),
         .addr_w(wr_addr),
         .addr_r_1(op0),
         .addr_r_2(op1[mem_sz-1: 0]),
         .data_w(data_w),
         .data_r_1(alu_in_1),
         .data_r_2(alu_in_2)
);





alu #(.op_sz(op_sz)) alu_op(
.clk(clk),
.reset(reset),
.op(op),
.in_1(alu_in_1),
.in_2(alu_in_2),
.out(alu_out),
.op_err(op_err),
.op_done(op_done)
);

always@(posedge clk) begin

 out_reg <= out_next ;

end

// write and read operation 
//
always @(*) begin
out_next =0;
case(op)
 write: begin 
    out_next <= op1 ;//value from the input
    wr_addr <= op0;
    data_w <= op1;
    we <=1;    
 end
 read: begin 
    out_next <= alu_in_1 ;//value from a memory address
    wr_addr <= op0;
    data_w <= op1;
    we <= 0; // to prevent writing     
 end
  default: begin
     out_next <= out_reg ;
    wr_addr <= op2;
     data_w <= alu_out;
     if(~op_err && op_done)
     we <=1;
     else we<= 0;   
   end
endcase
end



//
assign out = out_reg ;




endmodule




