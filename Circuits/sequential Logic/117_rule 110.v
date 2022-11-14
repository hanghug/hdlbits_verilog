module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
	
    wire[511:0] q_lft = q<<1;  //左移对应它的右边
    wire[511:0] q_rgt = q>>1;  //右移对应它的左边
    
    always @(posedge clk) begin 
        if (load) 
            q <= data;
        else 
            q <= ~q_rgt&q_lft | q&~q_lft | ~q&q_lft;
    end
endmodule
