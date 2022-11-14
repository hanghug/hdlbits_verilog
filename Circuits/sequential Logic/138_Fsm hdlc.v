module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);


    parameter 
        None = 3'd0,
        Data = 3'd1,
        Disc = 3'd2,
        Flag = 3'd3,
        Error = 3'd4;

    reg [2:0] st,next_st;
    reg [2:0] cnt;

    always @(*) begin
        case (st)
            None : 
                next_st = in ? Data : None;
            Data :
                if (cnt == 3'd5) 
                    next_st = in ? Data : Disc;
                else if (cnt == 3'd6)
                    next_st = in ? Error : Flag;
                else    
                    next_st = in ? Data : None;
            Disc, Flag :
                next_st = in ? Data : None;
            Error :
                next_st = in ? Error : None;
            default: 
                next_st = None;
        endcase
    end

    always @(posedge clk) begin
        if(reset)
            st <= None;
        else 
            st <= next_st;
    end

    always @(posedge clk) begin
        if (reset)
            cnt <= 3'd0;
        else if (next_st == Data) //这次查询当前状态，不查上个状态了
            cnt <= cnt + 1'd1;
        else 
            cnt <= 3'd0;  //在非Data状态，组合逻辑中使用的是上一个状态的cnt，这里会更新新的cnt
    end

    assign disc = st==Disc;
    assign flag = st==Flag;
    assign err = st==Error;

endmodule
