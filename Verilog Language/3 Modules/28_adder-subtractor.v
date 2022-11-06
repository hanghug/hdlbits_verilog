module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire cout;
    wire [31:0] b1;

    assign b1 = b ^ {32{sub}};
    add16 U1 (a[15:0],b1[15:0],sub,sum[15:0],cout);
    add16 U2 (a[31:16],b1[31:16],cout,sum[31:16]);
    //add16 U2 (a[31:16],b1[31:16],cout,sum[31:16], );  枚举不完全时可以只写, 不写后面的wire类型数据

endmodule
