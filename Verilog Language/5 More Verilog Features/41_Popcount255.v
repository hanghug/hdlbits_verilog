module top_module( 
    input [254:0] in,
    output reg [7:0] out 
);
    integer i;
    always @(*) begin
        out = 0;
        for (i = 0;i < 255;i = i + 1) begin
            //if (in[i] == 1'b1) out = out + 1;  不太好
            out = out + in[i]; // 更巧妙
        end
    end
endmodule
