module top_module( 
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );

    // assign out_both = in[2:0] & in[3:1];
    // assign out_any = in[3:1] | in[2:0];
    // assign out_different = in[3:0] ^ {in[0],in[3:1]}; 

    always @(*) begin
        integer i;
        for (i = 0; i < 3; i = i + 1) begin  //对[2:0]进行处理
            out_both[i] = in[i] & in[i+1];
            out_any[i+1] = in[i+1] | in[i];
            out_different[i] = in[i] ^ in[i+1];
        end

        out_different[3] = in[3] ^ in[0];
    end

endmodule
