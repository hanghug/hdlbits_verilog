/*
三段式模板：
 一个always模块采用同步时序描述状态转移；一个always模块采用组合逻辑判断状态转移条件，
 描述状态转移规律；另一个always模块描述状态输出（可以用组合电路输出，也可以时序电路输出）。
二段式模板：
一个always模块采用同步时序描述状态转移；另一个always模块采用组合逻辑判断状态转移条件，
描述状态转移规律以及输出。
一段式模板：
主要是将所有的状态变化以及导致的输出变化都写在了一个always模块中。
*/

module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1;  //状态图规定的二进制状态编码。
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        // State transition logic
        case(state) 
         	A : next_state = in ? A : B;
            B : next_state = in ? B : A;
        endcase
    end

    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
        if (areset) 
            state <= B;
        else 
            state <= next_state;
    end

    // Output logic
    // assign out = (state == ...);
    assign out = (state==B);
    
endmodule
