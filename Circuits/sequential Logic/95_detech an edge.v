module top_module (
    input clk,
    input [7:0] in,
    output [7:0] reg pedge
);
	
    reg [7:0] in_reg;
    always @(posedge clk) begin
    	in_reg <= in;
    end
    
    // always @(posedge clk) begin
    //     integer i;
    //     for (i = 0; i <= 7; i = i+1) begin
    //         pedge[i] = {in_reg[i],in[i]}==2'b01;  //上升沿检测，只维持一拍
    //     end
    // end

    // 化简写法
    always @(posedge clk) begin
        pedge = ~in_reg & in;
    end
    
endmodule
