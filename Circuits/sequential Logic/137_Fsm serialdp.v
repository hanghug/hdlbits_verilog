//再做：2022年11月23日09:37:15
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
    wire odd;
    reg odd_delay;
    
    always @(posedge clk) begin
        if (reset)
            out_byte_reg <= 8'd0;
        else if (next_st == DATA && cnt < 4'd8)
            out_byte_reg[cnt] <= in; 
    end      // 更新的是上一拍的cnt，与cnt+1同时进行，此拍同时更新cnt

    always @(posedge clk) begin
        odd_delay <= odd;    
    end

    always @(*) begin
        case(st) //此时的st相当于上一拍的st
            IDLE:
                next_st = in ? IDLE : BGN;
            BGN:
                next_st = DATA;
            DATA:
                next_st = cnt<4'd9 ? DATA : (in ? STP : WAIT);  
            STP:   
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

    // always @(posedge clk) begin
    //     if (reset)
    //         cnt <= 4'd0;
    //     else if (next_st == DATA)  
    //         cnt <= cnt + 4'd1;
    //     else if (next_st == BGN)
    //         cnt <= 4'd0;
    //     else 
    //         cnt <= cnt;                  
    // end
    // 也行
    always @(posedge clk) begin
        if (reset)
            cnt <= 4'd0;
        else if (next_st == DATA)  
            cnt <= cnt + 4'd1;
        else 
            cnt <= 4'd0;                
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
                done = odd_delay ? 1'b1 : 1'b0;
                out_byte = done ? out_byte_reg : 8'd0; 
            end        
                
            WAIT: begin
                done = 1'b0;  
                out_byte = 8'd0;
            end
                          
        endcase
    end

    parity U1(
        .clk(clk),
        .reset(reset || next_st==BGN),
        .in(in),
        .odd(odd)
    );

endmodule




// 错误的,错误在于cnt的判断，本代码用的cnt除了更新cnt的块以外，其它块使用的都是上一拍的cnt，而不是当前拍。 
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
    wire odd;
    reg odd_delay;
    
    always @(posedge clk) begin
        if (reset)
            out_byte_reg <= 8'd0;
        else if (next_st == DATA && cnt < 4'd7)
            out_byte_reg[cnt] <= in; //先来的是低位
    end      // 更新的是上一拍的cnt，与cnt+1同时进行，此拍同时更新cnt

    always @(posedge clk) begin
        odd_delay <= odd;    
    end

    always @(*) begin
        case(st) //此时的st相当于上一拍的st
            IDLE:
                next_st = in ? IDLE : BGN;
            BGN:
                next_st = DATA;
            DATA:
                next_st = cnt<4'd8 ? DATA : (in ? STP : WAIT);  
            STP:   //从0开始计数，当下一拍检测到上一拍计数为8时，说明8位+校验位采集完毕。
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
        else if (st == DATA)  //上升沿到来时以更新后的st状态来判断。
            cnt <= cnt + 4'd1;
        else 
            cnt <= 4'd0;   // 这里改了             
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
                done = odd_delay ? 1'b1 : 1'b0;
                out_byte = done ? out_byte_reg : 8'd0; 
            end        
                
            WAIT: begin
                done = 1'b0;  
                out_byte = 8'd0;
            end
                          
        endcase
    end

    parity U1(
        .clk(clk),
        .reset(reset || next_st==BGN),
        .in(in),
        .odd(odd)
    );

endmodule



/**
实现功能：偶数个1时odd为0，奇数个1时odd为1。
*/
module parity (
    input clk,
    input reset,
    input in,
    output reg odd);

    always @(posedge clk)
        if (reset) odd <= 0;
        else if (in) odd <= ~odd; 

endmodule











//=======================================================================================
/*
奇偶校验码，传输时发送方多发送一位校验位，使所有数据满足奇数个1或者偶数个1。
以发送8位数据为例，发送8位数据后，紧接着再发送一个校验位(1/0)，使其满足
共9位的数据中有奇数个1(奇校验)，或者偶数个1(偶校验)。
*/

module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    parameter
        IDLE = 3'd0,  //就是下面写的stp_WAIT
        bgn = 3'd1,
        S = 3'd2,
        stp = 3'd3,
        WAIT = 3'd4;

    reg [2:0] st,next_st;
    reg [3:0] cnt;
    reg [8:0] out_byte_reg;
    wire odd;

    always @(*) begin
        case (st)
            bgn:
                next_st = S;
            S:
                if (cnt == 4'd8) next_st = in ? stp : WAIT;
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

    always @(posedge clk) begin
        if(reset) 
            out_byte_reg <= 9'd0;
        else if (next_st == S)  
            out_byte_reg <= {in,out_byte_reg[8:1]};
        else if (next_st == stp)
            out_byte_reg <= out_byte_reg;
        else
            out_byte_reg <= 9'd0;
    end

    /*每个时钟周期odd都会对当前输入进行一次判定，
    在bgn阶段，in为0，所以无影响。
    在stp阶段，in为1时，会再造成一次翻转，会影响，
    因此Stpq前的状态才是数据[8:0]的奇校验，不然会多一个停止位1。
    */
    reg odd_stp; 
    always @(posedge clk) begin
          odd_stp <= odd;  
    end

    assign done = st==stp && odd_stp;
    assign out_byte = done ? out_byte_reg[7:0] : 8'd0;


    parity parity_case(
        .clk(clk),
        .reset(reset || next_st==bgn),
        .in(in), //在每次异或或者bgn位置时，将odd清0，在bgn周期清零，下个周期刚好传入数据。
        .odd(odd)
    );

endmodule

module parity (
    input clk,
    input reset,
    input in,
    output reg odd);

    always @(posedge clk)
        if (reset) odd <= 0;
        else if (in) odd <= ~odd;

endmodule