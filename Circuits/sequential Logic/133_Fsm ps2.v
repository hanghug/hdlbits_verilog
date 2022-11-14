// 二段式
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //


    reg [1:0] st,next_st;
    localparam WAIT = 2'd0, D1 = 2'd1, D2 = 2'd2, D3=2'd3;
    // wait状态是等待in[3]为1的出现，认为它是开始的第一个字节，否则一直等待。 

    // State flip-flops (sequential)
    always@(posedge clk) begin
        if (reset) 
            st <= WAIT;
        else begin
            case(st)
            WAIT: 
                if (in[3]) st <= D1;
                else st <=  WAIT;
            D1:
                st <= D2;
            D2: 
                st <= D3;
            D3:  //和WAIT对应的输出(done)不一样，不能合并。
                if (in[3]) st <= D1;
                else st <= WAIT;
            endcase
        end
    end
    
    // Output logic
    assign done = st==D3;

endmodule


// 三段式
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //


    reg [1:0] st,next_st;
    localparam WAIT = 2'd0, D1 = 2'd1, D2 = 2'd2, D3=2'd3;
    // wait状态是等待in[3]为1的出现，认为它是开始的第一个字节，否则一直等待。 
    
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

endmodule
