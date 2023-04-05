`timescale 1ns / 1ps

module top(
    input clk_in,
    input reset,
    output led
    );
    
    reg [26:0] count=0;
    reg clk_out;
    
    reg [7:0] arr = 8'b11001100;
    
    reg [7:0] q_reg;
  
    always @(posedge clk_in)
    begin
    //if(~reset)
    //begin
    count <= count + 1;
    if(count == 125_000_000)
    begin
    count <= 0;
    clk_out = ~clk_out;
    end
    end
    //end
//    assign led = clk_out;
    
    always @(posedge clk_out)
    begin
    if(reset)
    q_reg <= arr;
    else
    begin
   /* q_reg[7] <= 1'bx;
    q_reg[6] <= q_reg[7];
    q_reg[5] <= q_reg[6];
    q_reg[4] <= q_reg[5];
    q_reg[3] <= q_reg[4];
    q_reg[2] <= q_reg[3];
    q_reg[1] <= q_reg[2];
    q_reg[0] <= q_reg[1];
     */
    // for right shifting
    q_reg[0] <= 1'bx;
    q_reg[1] <= q_reg[0];
    q_reg[2] <= q_reg[1];
    q_reg[3] <= q_reg[2];
    q_reg[4] <= q_reg[3];
    q_reg[5] <= q_reg[4];
    q_reg[6] <= q_reg[5];
    q_reg[7] <= q_reg[6];
    
    end
    end
    
    //assign led = q_reg[0];
    assign led = q_reg[7];
endmodule
