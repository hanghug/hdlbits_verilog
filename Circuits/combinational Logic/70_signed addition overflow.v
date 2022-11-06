module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); 
	
    wire [8:0] a_expand= {a[7],a};  //扩展符号位
    wire [8:0] b_expand= {b[7],b};
    wire [8:0] s_expand;
    
    assign s_expand = a_expand + b_expand;
    assign s = s_expand[7:0];
    assign overflow = s_expand[8] ^ s_expand[7];
    
    //assign s = a + b;
    //assign overflow = a[7]!=b[7] ? 1'b0 : s[7]==a[7] ? 1'b0 : 1'b1;

endmodule


