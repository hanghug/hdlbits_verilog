// 简洁实现，省略S1到S8状态
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    parameter
        IDLE = 3'd0,  //就是下面写的stp_WAIT
        bgn = 3'd1,
        S = 3'd2,
        stp = 3'd3,
        WAIT = 3'd4;

    reg [2:0] st,next_st;
    reg [3:0] cnt;

    always @(*) begin
        case (st)
            bgn:
                next_st = S;
            S:
                if (cnt == 4'd7) next_st = in ? stp : WAIT;
                else next_st = st;
            stp:
                next_st = in ? IDLE : bgn;
            WAIT:
                next_st = in ? IDLE : st;
            IDLE:
                next_st = in ? IDLE : bgn;        
            default: 
                next_st = IDLE;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            st <= IDLE;
        end
        else begin
            st <= next_st;
        end
    end

    always @(posedge clk) begin
        if(reset) 
            cnt <= 4'd0;
        else if (st == S)  //st==S相比输入晚两拍， next_st==S相比输入晚1拍
            cnt <= cnt + 1'd1;
        else
            cnt <= 4'd0;
    end

    assign done = st==stp;

endmodule







// 法2 三段式
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    reg [7:0] data;
    reg [3:0] st,next_st;
    parameter bgn=4'd0,S1=4'd1,S2=4'd2,S3=4'd3,S4=4'd4, S5=4'd5;
    parameter S6=4'd6,S7=4'd7,S8=4'd8,stp=4'd9,WAIT=4'd10,stp_WAIT=4'd11;

    always @(*) begin
        case(st) 
                bgn:
                    next_st = S1;
                S1:
                    next_st =S2;
                S2:
                    next_st = S3;  
                S3:
                    next_st = S4;  
                S4:
                    next_st = S5;  
                S5:
                    next_st = S6;  
                S6:
                    next_st = S7;  
                S7:
                    next_st = S8;
                S8:
                    if (in) next_st = stp;
                    else next_st = WAIT;
                stp: // 完整的接受结束了，看我是继续等待 还是继续接收新的
                    if (in) next_st = stp_WAIT; 
                    else next_st = bgn;
                WAIT:
                    if (in) next_st = stp_WAIT;
                    else next_st = st;
                stp_WAIT:
                    if (!in) next_st = bgn;
                    else next_st = st;               
        endcase
    end    

    always @(posedge clk) begin
        if (reset) 
            st <= stp_WAIT; 
        else 
            st <= next_st;
    end

    assign done = st==stp;

endmodule







// 法1 非二段式 非三段式
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    reg [7:0] data;
    reg [3:0] st;
    parameter bgn=4'd0,S1=4'd1,S2=4'd2,S3=4'd3,S4=4'd4;
    parameter S5=4'd5,S6=4'd6,S7=4'd7,S8=4'd8,stp=4'd9,WAIT=4'd10,stp_WAIT=4'd11;

    always @(posedge clk) begin
        if (reset) 
            st <= stp_WAIT; 
        else begin
            case(st)
                bgn:
                    st <= S1;
                S1:
                    st <= S2;
                S2:
                    st <= S3;  
                S3:
                    st <= S4;  
                S4:
                    st <= S5;  
                S5:
                    st <= S6;  
                S6:
                    st <= S7;  
                S7:
                    st <= S8;
                S8:
                    if (in) st <= stp;
                    else st <= WAIT;
                stp:
                    if (in) st <= stp_WAIT; 
                    else st <= bgn;
                WAIT:
                    if (in) st <= stp_WAIT;
                    else st <= st;
                stp_WAIT:
                    if (!in) st <= bgn;
                    else st <= st;                                      
            endcase
        end
    end

    assign done = st==stp;
endmodule
