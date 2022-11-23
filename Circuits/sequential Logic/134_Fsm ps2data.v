//2022-11-20再做
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output reg done); //

    parameter WAIT = 2'd0, D1 = 2'd1, D2 = 2'd2, D3 = 2'd3;
    reg [1:0] st,next_st;

    reg [23:0] out_bytes_reg;
    assign out_bytes = out_bytes_reg; //只有done信号为1的时候的值才有用，否则没用。

    always @(posedge clk) begin
        if (reset)
            out_bytes_reg = 24'd0;
        else
            out_bytes_reg = {out_bytes_reg[15:0],in};    
    end

    always @(*) begin
        case (st)
            WAIT: begin    // 注意处理next_st和done的条件的st不是同一个st。
                next_st = in[3] ? D1 : WAIT;  done = 1'b0;
            end
                
            D1: begin
                next_st = D2; done = 1'b0;
            end
                
            D2: begin
                next_st = D3; done = 1'b0;
            end

            D3: begin
                next_st = in[3] ? D1 : WAIT;    done = 1'b1;
            end     

            default: begin
                next_st = WAIT;  done = 1'b0;
            end     
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            st <= WAIT;
        else 
            st <= next_st;    
    end 

endmodule


















//=================================================================================
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //


    reg [1:0] st,next_st;
    localparam WAIT = 2'd0, D1 = 2'd1, D2 = 2'd2, D3=2'd3;
    // wait状态是等待in[3]为1的出现，认为它是开始的第一个字节，否则一直等待。 
    reg [23:0] out_bytes_reg;


    // 该题中，in信号和上升沿信号同时变化，所以每次上升沿检测到的是上一拍的in。
    // 即状态检测相比输入in要延后一拍。
    always @(posedge clk) begin
        if (reset)  
            out_bytes_reg <= 24'd0;
        else begin
            out_bytes_reg[7:0] <= in;
            out_bytes_reg[15:8] <= out_bytes_reg[7:0];
            out_bytes_reg[23:16] <= out_bytes_reg[15:8];
        end
    end

    // State transition logic (combinational)
    always @(*) begin
        case (st)
            WAIT: 
                if (in[3]) next_st = D1;
                else next_st =  WAIT;
            D1:
                next_st = D2;
            D2: 
                next_st = D3;
            D3:  //和WAIT对应的输出(done)不一样，不能合并。
                if (in[3]) next_st = D1;
                else next_st = WAIT;
        endcase
    end

    // State flip-flops (sequential)
    always@(posedge clk) begin
        if (reset) 
            st <= WAIT;
        else
            st <= next_st;
    end
    
    // Output logic
    assign done = st==D3;
    assign out_bytes = done ? out_bytes_reg : 24'b0;

endmodule
