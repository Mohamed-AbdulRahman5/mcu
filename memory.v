




module memory #(parameter Addr_width =4 , data_width=8) (
input clk ,//synchronus memory
input we,//wirte and read enable
input [Addr_width - 1: 0]addr_w,// data write adress
input [Addr_width - 1: 0]addr_r_1,// data read adress
input [Addr_width - 1: 0]addr_r_2,
input [data_width-1:0] data_w,//dara wirte
output  [data_width-1:0] data_r_1,//data read
output  [data_width-1:0] data_r_2

);

/// describing a memory 2^addr width * data width(byte)
 reg [data_width-1:0] mem [0: 2**Addr_width -1 ] ;
 
//opreation on memory

always@(posedge clk)
begin 
 
 // write on we 1
 if(we)  
  mem[addr_w] <= data_w ;//writing into memory 


 
 //asyn read
 
assign data_r_1 = mem[addr_r_1];
assign data_r_2 = mem[addr_r_2];
 
  
endmodule








