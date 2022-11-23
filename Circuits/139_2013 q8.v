//再做：2022年11月23日20:49:34

module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 

    parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2;
    reg [1:0] st,next_st;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            st <= S0;
        else 
            st <= next_st;
    end

    always @(*) begin
        case(st) 
            S0: begin
                next_st = x ? S1 : S0; //已经检测到S0状态(上一拍的状态)了，我要做什么？
                z = 1'b0;  //我当前是S0状态，我要做什么？  Moore型：我直接输出；Mealy型：我再看看当前输入是啥。
            end      
            S1: begin
                next_st = x ? S1 : S2;
                z = 1'b0;
            end
            S2: begin
                next_st = x ? S1 : S0; 
                z = x ? 1'b1 : 1'b0;
            end
                 
        endcase
    end

endmodule











// 实现一个检测101的Mealy状态机，可重复使用输入。
module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z );     

    parameter IDLE = 2'b00, S1 = 2'b01, S2 = 2'b11;
                        //S1(1序列)      S2(10序列)
    reg [1:0]  st,next_st;
                       
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            st <= 2'd0;
        else 
            st <= next_st;
    end

    always @(*) begin
        case(st) 
            IDLE:
                next_st = x ? S1 : IDLE;
            S1:
                next_st = x ? S1 : S2;
            S2:
                next_st = x ? S1 : IDLE;
            default:
                next_st = IDLE;
        endcase
    end

    // 前一拍是S
    assign z = (st==S2)&&(x==1'b1) ? 1'b1 : 1'b0;

endmodule
