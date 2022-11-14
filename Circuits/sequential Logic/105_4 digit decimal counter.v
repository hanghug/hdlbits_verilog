module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);


    // assign ena[1] = q[3:0]==4'd9;   // 个位进位的信号
    // assign ena[2] = q[3:0]==4'd9&&q[7:4]==4'd9;  //十位进位的信号
    // assign ena[3] = q[3:0]==4'd9&&q[7:4]==4'd9&&q[11:8]==4'd9; //百位进位的信号
    assign ena[1] = q[3:0]==4'h9; 
    assign ena[2] = q[7:0]==8'h99;
    assign ena[3] = q[11:0]==12'h999;  //后两个写8'd99 12'd999会报错的。

    bcdcount b0 (clk,reset,1'b1,q[3:0]);  //一直工作 个位
    bcdcount b1 (clk,reset,ena[1],q[7:4]);
    bcdcount b2 (clk,reset,ena[2],q[11:8]);
    bcdcount b3 (clk,reset,ena[3],q[15:12]);
     
endmodule

//BCD计数器，从0到9
module bcdcount(
    input clk,
    input reset,
    input ena,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (!ena) 
            q <= q;
        else 
            q <= (q==9) ? 4'd0 : q+1'b1;     
    end

endmodule