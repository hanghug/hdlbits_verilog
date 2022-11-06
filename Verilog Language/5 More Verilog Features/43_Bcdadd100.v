module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum 
);

    wire [99:0] cout_temp;
    assign cout = cout_temp[99];

    bcd_fadd U0(a[3:0],b[3:0],cin,cout_temp[0],sum[3:0]);

    genvar i;
    generate for (i = 1;i < 100; i = i + 1) 
    begin:BCDadd_100
        bcd_fadd Ui(a[4*i+3:4*i],b[4*i+3:4*i],cout_temp[i-1],cout_temp[i],sum[4*i+3:4*i]);
    end
    endgenerate
    
endmodule
