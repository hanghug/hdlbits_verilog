// begin 2022年11月23日17:06:51
//end 2022年11月23日17:28:59
module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

    parameter IDLE = 3'd0, Detect = 3'd1, DISC = 3'd2, FLAG = 3'd3, ERR = 3'd4;
    reg [2:0] st,next_st;
    reg [2:0] cnt;

    always @(posedge clk) begin
        if (reset)
            st <= IDLE;
        else 
            st <= next_st;
    end

    always @(posedge clk) begin
        if (reset)
            cnt <= 3'd0;
        else if (next_st == Detect)
            cnt <= cnt + 1'b1;
        else    
            cnt <= 3'd0;     
    end

    always @(*) begin
        case (st)  //这是上一拍的st
            IDLE:
                next_st = in ? Detect : IDLE;
            Detect: begin // 总感觉这个if判断可以改进，还是得需要知道它的实际电路才能判断是不是会硬件冗余。现在我还没这能力
                if (!in && cnt == 3'd5)  // 这个cnt是上一拍的cnt值
                    next_st = DISC;
                else if (!in && cnt == 3'd6)
                    next_st = FLAG;
                else if (in && cnt == 3'd6)
                    next_st = ERR;
                else
                    next_st = in ? Detect : IDLE; 
            end               
            DISC, FLAG:  
                next_st = in ? Detect : IDLE;
            ERR:
                next_st = in ? ERR : IDLE;
        endcase
    end

    always @(*) begin
        case (st)  //这是更新后的st，即next_st，当前拍的st
            IDLE, Detect: begin
                disc = 0;  flag = 0; err = 0;
            end
            DISC: begin
                disc = 1'b1;  flag = 0; err = 0;
            end
            FLAG: begin
                disc = 0;  flag = 1'b1; err = 0;
            end
            ERR: begin
                disc = 0;  flag = 0; err = 1'b1;
            end       
        endcase
    end

endmodule

















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
