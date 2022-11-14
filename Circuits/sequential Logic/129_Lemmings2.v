// 地面出现和碰撞同时出现，先恢复原方向，再过一个时钟周期再考虑碰撞。
//地面消失和撞到同时出现呢？ 应该是先考虑下落吧。
// lft rgt fall 三个状态同时只有一个为1。

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    parameter lft = 2'd0, rgt = 2'd1 , fall_lft = 2'd2, fall_rgt = 2'd3;
    reg [2:0]st, next_st;  

    always @(*) begin
        case(st)
            2'd0:
                if (!ground) begin
                    next_st = fall_lft;
                end
                else if (bump_left)  next_st = rgt; 
                else next_st = lft;
            2'd1:
                if (!ground) begin 
                    next_st = fall_rgt;
                end    
                else if (bump_right)  next_st = lft; 
                else next_st = rgt;
            2'd2:
                if (ground) next_st = lft;
                else next_st = fall_lft;
            2'd3:
                if (ground) next_st = rgt;
                else next_st = fall_rgt;   
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) 
            st <= lft;
        else
            st <= next_st;
    end    

    assign walk_left = st==lft;
    assign walk_right = st==rgt;
    assign aaah = st==fall_lft|st==fall_rgt;
    // 这三者同时只有一个为1

endmodule

// module top_module(
//     input clk,
//     input areset,    // Freshly brainwashed Lemmings walk left.
//     input bump_left,
//     input bump_right,
//     input ground,
//     output walk_left,
//     output walk_right,
//     output aaah ); 

//     parameter lft = 2'd0, rgt = 2'd1 , fall = 2'd2;
//     reg [1:0]temp_st;
//     reg [1:0]st, next_st;   //这里记得也变成两位  

//     always @(*) begin
//         case(st)
//             2'd0:
//                 if (!ground) begin
//                     next_st = fall;
//                     temp_st = lft;
//                 end
//                 else if (bump_left)  next_st = rgt; 
//                 else next_st = st;
//             2'd1:
//                 if (!ground) begin 
//                     next_st = fall;
//                     temp_st = rgt;
//                 end    
//                 else if (bump_right)  next_st = lft; 
//                 else next_st = st;
//             2'd2:
//                 if (ground) next_st = temp_st;
//                 else next_st = st;
//         endcase
//     end

//     always @(posedge clk, posedge areset) begin
//         // State flip-flops with asynchronous reset
//         if (areset) 
//             st <= lft;
//         else
//             st <= next_st;
//     end    

//     assign walk_left = st==lft;
//     assign walk_right = st==rgt;
//     assign aaah = st==fall;
//     // 这三者同时只有一个为1

// endmodule
