module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);
	
    reg [31:0] in_reg;
    always @(posedge clk) begin
        // if (reset)  //同步复位
    	// 	in_reg <= 32'b0;
        // else
            in_reg <= in;
    end
//错了，是要一直保持状态，不是只维持一拍了。
    // always @(posedge clk) begin 
    // 	if (reset) 
    //         out <= 32'b0;
    //     else 
    //         out = in_reg & ~in;
    // end

    always @(posedge clk) begin 
        if (reset)
            out <= 32'b0;
        else begin
            integer i;
            for (i = 0 ; i <= 31; i = i+1) begin
                out[i] <= ({in_reg[i],in[i]}==2'b10) ? 1'b1 : out[i]; 
            end
        end    

    end
endmodule
