//对三段式上面的解析，可以理解为三段式 二段式 一段式是一种规范，
// 但这是我们自己写的状态机，同样可以实现功能。

// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    // Fill in state name declarations
	parameter A = 1'b0, B = 1'b1;
    
    reg state, next_state;
	
    always @(posedge clk) begin
        if (reset) begin  
            state <= B;
        end 
        else begin
            case (state)
                A : 
                	if (in) state <= A;
                	else state <= B;
                B :	
                    if (in) state <= B;
                	else state <= A;
            endcase
        end
    end
	
    assign out = (state == B);
    
endmodule
