
// 法一
module top_module ( input [1:0] A, input [1:0] B, output z ); 

// 这样是错误的
//    if (A==B) 
//       assign z = 1'b1;
//    else 
//       assign z = 1'b0;
    assign z = (A==B)?1'b1:1'b0;  // 这样才对
endmodule


//法二
module top_module ( input [1:0] A, input [1:0] B, output z ); 
	
    always @(*) begin
        if (A==B) 
            z = 1'b1;
        else 
            z = 1'b0;
    end

endmodule