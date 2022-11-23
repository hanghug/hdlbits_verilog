// 再做：2022年11月24日00:13:41

module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

    parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2;
    reg [1:0] st,next_st;

    always @(posedge clk or posedge areset) begin
        if (areset)
            st <= S0;
        else 
            st <= next_st;    
    end

    always @(*) begin
        case(st) 
            S0:
                next_st = x ? S1 : S0;
            S1:
                next_st = x ? S2 : S1;
            S2:
                next_st = x ? S2 : S1;        
        endcase
    end

    always @(*) begin
        case(st)
            S0:
                z = 1'b0;
            S1:
                z = 1'b1;
            S2:
                z = 1'b0;
        endcase
    end
endmodule





















module top_module (
    input clk,
    input areset,
    input x,
    output reg z
); 

    reg [1:0] st,next_st;
    parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2;

    always @(*) begin
        case (st)
            S0: begin
                next_st = x ? S1 : S0; //已经检测到S0状态(上一拍的状态)了，我要做什么？
                z = 1'b0; //我当前是S0状态，我要做什么？
            end

            S1: begin
                next_st = x ? S2 : S1;
                z = 1'b1;
            end

            S2: begin
                next_st = x ? S2 : S1;
                z = 1'b0;  
            end           
            default:  begin
                next_st = S0;
                z = 1'b0;
            end    
        endcase
    end


    always @(posedge clk or posedge areset) begin
        if(areset) begin
            st <= S0;
        end
        else begin
            st <= next_st;
        end
    end
endmodule
