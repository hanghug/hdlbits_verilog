// 再做：2022年11月22日00:17:34
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    parameter IDLE = 3'd0, BGN = 3'd1, DATA=3'd2, STP = 3'd3,WAIT = 3'd4;
    reg [2:0] st,next_st;
    reg [3:0] cnt;
    
    reg [7:0] out_byte_reg;
    always @(posedge clk) begin
        if (reset)
            out_byte_reg <= 8'd0;
        else if (next_st == DATA)
            out_byte_reg = {in,out_byte_reg[7:1]};
            
    end 

    always @(*) begin
        case(st) //此时的st相当于上一拍的st
            IDLE:
                next_st = in ? IDLE : BGN;
            BGN:
                next_st = DATA;
            DATA:
                next_st = cnt<4'd8 ? DATA : (in ? STP : WAIT);  
            STP:         //从1开始计数，当下一拍检测到上一拍计数为8时，说明8位采集完毕。
                next_st = in ? IDLE : BGN;
            WAIT:
                next_st = in ? IDLE : WAIT;              
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            st <= IDLE;
        else
            st <= next_st;     
    end

    always @(posedge clk) begin
        if (reset)
            cnt <= 4'd0;
        else if (next_st == DATA)  //上升沿到来时以更新后的st状态来判断。
            cnt <= cnt + 4'd1;
        else if (next_st == BGN)
            cnt <= 4'd0;
        else 
            cnt <= cnt;  //时序逻辑中这句话不写也行。                
    end

    always @(*) begin
        case(st) //此时的st相当于next_st
            IDLE: begin
                done = 1'b0;
                out_byte = 8'd0;
            end    
            BGN:begin
                done = 1'b0;
                out_byte = 8'd0;
            end    
            DATA: begin
                done = 1'b0;
                out_byte = 8'd0;
            end
                
            STP: begin
                done = 1'b1;
                out_byte = out_byte_reg; //其它状态是out_byte怎么输出最好也写上，不然会有latch
            end        
                
            WAIT: begin
                done = 1'b0;  
                out_byte = 8'd0;
            end
                          
        endcase
    end

endmodule





















//=======================================================================================
// 简洁实现，省略S1到S8状态
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
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
    reg [7:0] out_byte_reg;

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
        else if (st == S)  //st==S相比输入晚两拍，对状态而言相当于从0开始计数 
            cnt <= cnt + 1'd1; // next_st==S相比输入晚1拍，对状态而言相当于从1开始计数 
        else               // 这一切的前提都是 输入和时钟上升沿一起变化，每次处理的是前一拍的输入
            cnt <= 4'd0;
    end

    always @(posedge clk) begin
        if(reset) 
            out_byte_reg <= 8'd0;
        else if (next_st == S)  
            out_byte_reg <= {in,out_byte_reg[7:1]};
        else if (next_st == stp)
            out_byte_reg <= out_byte_reg;
        else
            out_byte_reg <= 8'd0;
    end

    assign done = st==stp;
    assign out_byte = done ? out_byte_reg : 8'b0;

endmodule





















module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); 

    reg [3:0] st,next_st;
    parameter bgn=4'd0,S1=4'd1,S2=4'd2,S3=4'd3,S4=4'd4, S5=4'd5;
    parameter S6=4'd6,S7=4'd7,S8=4'd8,stp=4'd9,WAIT=4'd10,stp_WAIT=4'd11;

    reg [7:0] out_byte_reg;

    always @(posedge clk) begin
        if (reset)
            out_byte_reg <= 8'd0;
        else if (next_st!=stp)  //当成功的时候，停止位就不移位了。
            out_byte_reg <= {in,out_byte_reg[7:1]}; 
    end //先传进来的是最低位，所以进行右移，8次之后，刚好最低位在最后面。

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
    assign out_byte = done ? out_byte_reg : 8'b0;
    
endmodule