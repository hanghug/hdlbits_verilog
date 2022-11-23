//2022-11-20再做
// 经判断，该网站中是每次更新拿上一个状态的st和上一个状态的in为条件的。


// 待拓展：
//  还有优化的空间，如果接收的是连续5 6 7 甚至n个呢？
// 设置一个计数器。



module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output reg done); //

    parameter WAIT = 2'd0, D1 = 2'd1, D2 = 2'd2, D3 = 2'd3;
    reg [1:0] st,next_st;

    // 为什么要分开写呢？ 因为虽然是并行的，但是这两个语句块执行的时机并不一样。
    // 先执行一，一中拿到的st是旧的st，以此来更新next_st
    // 再执行三，三拿一中的next_st来更新st
    // 最后执行二，二中case执行的是三中的st状态，即现态(next_st)，而不是一中的上一个状态(st)。
    // 最后要说明的是一中的st和三中的st其实已经不是一种st。
    always @(*) begin //一
        case (st)
            WAIT: 
                next_st = in[3] ? D1 : WAIT; //已经检测到WAIT状态了，我需要做什么？
            D1: 
                next_st = D2; 
            D2: 
                next_st = D3; 
            D3: 
                next_st = in[3] ? D1 : WAIT;       
            default: 
                next_st = WAIT;  
        endcase
    end

    always @(*) begin // 二
        case (st)
            WAIT:
                done = 1'b0; //我当前是WAIT状态，我要做什么？
            D1: 
                done = 1'b0;
            D2: 
                done = 1'b0;
            D3: 
                done = 1'b1;    
            default: 
                done = 1'b0; 
        endcase
    end

    always @(posedge clk) begin //三 
        if (reset) 
            st <= WAIT;
        else 
            st <= next_st;    
    end 


    // 建议分开写。
    // always @(*) begin
    //     case (st)
    //         WAIT: begin
    //             next_st = in[3] ? D1 : WAIT;  done = 1'b0;
    //         end
                
    //         D1: begin
    //             next_st = D2; done = 1'b0;
    //         end
                
    //         D2: begin
    //             next_st = D3; done = 1'b0;
    //         end

    //         D3: begin
    //             next_st = in[3] ? D1 : WAIT;    done = 1'b1;
    //         end     

    //         default: begin
    //             next_st = WAIT;  done = 1'b0;
    //         end     
    //     endcase
    // end

endmodule



//=======================================================================================

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
