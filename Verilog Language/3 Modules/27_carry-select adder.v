module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] temp1,temp2;
    wire cout;
    add16 U1 (a[15:0], b[15:0], 1'b0, sum[15:0], cout);
    add16 U2 (a[31:16], b[31:16], 1'b0, temp1, );
    add16 U3 (a[31:16], b[31:16], 1'b1, temp2, );
    // if (cout) sum = {temp2,sum[15:0]};
    // else sum = {temp1,sum[15:0]};           sum[15:0]地方不可被重新赋值

    // if(cout) assign sum[31:16] = temp2;
    // else assign sum[31:16] = temp1;           仍然错

    assign sum[31:16] = cout ? temp2 : temp1;

endmodule
