module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output reg z
);

    reg[1:0] st,next_st;
    parameter A=2'd0,B1=2'd1,B2=2'd2,B3=2'd3;
    reg [1:0] cnt;

    always @(*) begin
        case(st)
            A :  begin
                next_st = s ? B1 : A;
                z = 1'b0;
            end
            B1 : begin
                next_st =  B2;
                z = cnt==2'd2;
            end
            B2 : begin
                next_st =  B3;
                z = 1'b0;
            end    
            B3 : begin
                next_st =  B1;
                z = 1'b0;
            end
            default: begin
                next_st = A;
                z = 1'b0;
            end  
        endcase
    end


    always @(posedge clk) begin
        if(reset) begin
            st <= A;
        end
        else begin
            st <= next_st;
        end
    end

    // 巧妙的化解了计数器怎么在一拍中清零并计数的操作。
    always @(posedge clk) begin
        if(reset)
            cnt <= 2'd0;
        else if (st == B1)
            cnt <= w;
        else if (st==B2 || st == B3)   
            cnt <= cnt + w;         
    end

endmodule
