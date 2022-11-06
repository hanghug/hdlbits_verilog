module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );
	
    // assign out = in[sel*4+3:sel*4];  不支持这种写
    assign out = in[sel*4 +: 4];   //效果和上面一样
    assign out = in[sel*4+3 -: 4];

    
endmodule
