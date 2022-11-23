//再做 2022年11月23日21:22:07
//Moore型。

module top_module(
    input clk,
    input in,
    input areset,
    output reg out); //

   parameter A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;
   reg [1:0] st,next_st;

   always @(posedge clk or posedge areset) begin
       if (areset)
            st <= A;
        else 
            st <= next_st;
   end

    always @(*) begin
        case (st) 
            A: begin// out和next_st用的也不是一个st，和之前理解的一样。
                next_st = in ? B : A; //已经检测到A状态(上一拍的状态)了，我要做什么？
                out = 1'b0;  //我当前是A状态，我要做什么？
            end 
            B:begin
                next_st = in ? B : C;
                out = 1'b0;
            end
            C:begin
                next_st = in ? D : A;
                out = 1'b0;
            end
            D:begin
                next_st = in ? B : C;
                out = 1'b1;
            end
        endcase
    end
endmodule




// 2022-11-8
module top_module(
    input clk,
    input in,
    input areset,
    output out); //
	
    parameter A=2'd0,B=2'd1,C=2'd2,D=2'd3;
    reg [1:0]st,next_st;
    
    // State transition logic
    always @(*) begin 
        case (st)
            2'd0:
                next_st = in?B:A;
            2'd1:
                next_st = in?B:C;
            2'd2:
                next_st = in?D:A;
            2'd3:
                next_st = in?B:C;
        endcase
    end
    
    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin 
        if (areset) 
            st <= A;
        else 
            st <= next_st;
    end
    // Output logic

    assign out = st==D; //前一拍是C状态，next_st为D状态，更新当前状态为D状态，然后out输出1。
    
endmodule
