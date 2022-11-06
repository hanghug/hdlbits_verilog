module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum 
);

    fadd U0(a[0],b[0],cin,sum[0],cout[0]);

    genvar i; //循环变量
    generate for (i = 1;i < 100;i = i + 1) 
        begin : add100 //name of block
            fadd Ui(a[i],b[i],cout[i-1],sum[i],cout[i]);
        end
    endgenerate

endmodule


module fadd(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign {cout,sum} = a + b + cin;

endmodule