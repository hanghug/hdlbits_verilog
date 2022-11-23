// 再做：2022年11月24日00:16:06
module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

    parameter S0 = 1'b0, S1 = 1'b1; 
              // S0:有进位 S1:无进位
    reg st,next_st;

    always @(posedge clk or posedge areset) begin
        if (areset)
            st <= S0;
        else 
            st <= next_st;    
    end

    always @(*) begin
        case(st) //上升沿状态(上一拍st)
            S0:
                next_st = x ? S1 : S0;
            S1:
                next_st = S1;     
        endcase
    end 

    always @(*) begin
        case(st) //更新后状态(当前拍st)
            S0:
                z = x;
            S1:
                z = ~x;     
        endcase
    end         
endmodule









//=============================================================================

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

    reg st,next_st;
    parameter S0 = 1'b0, S1 = 1'b1;

    always @(*) begin
        case(st) 
            S0: begin
                next_st = x ? S1 : st;
                z = x;
            end
                
            S1: begin
                next_st = st;
                z = ~x;
            end
        endcase
    end


    always @(posedge clk or posedge areset) begin
        if (areset) 
            st <= S0;
        else   
            st <= next_st; 
    end  

endmodule
