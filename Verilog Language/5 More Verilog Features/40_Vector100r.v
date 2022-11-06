module top_module( 
    input [99:0] in,
    output reg [99:0] out
);
    integer i;
    always @(*) begin
        for (i=0; i<100; i=i+1) begin
            out[i] = in[99-i]; 
        end
    end
endmodule


// module top_module( 
//     input [99:0] in,
//     output [99:0] out
// ); 
//     reg [99:0] out；                 这里写是错误的。这样声明端口时output和reg要写一起。
//     integer i;
//     always @(*) begin
//         for (i=0; i<100; i=i+1) begin
//             out[i] = in[99-i]; 
//         end
//     end
// endmodule
