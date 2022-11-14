/**
a walking Lemming can fall, dig, or switch directions. 
If more than one of these conditions are satisfied, 
fall has higher precedence than dig, which has higher 
precedence than switching directions.
这决定了状态转移时if判断的顺序
*/

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter  lft = 3'd0, rgt = 3'd1, fall_lft = 3'd2, fall_rgt = 3'd3, dig_lft = 3'd4,  dig_rgt = 3'd5;
    reg [3:0] st,next_st;

    always @(*) begin
        case(st)
            3'd0: 
                if (!ground) next_st <= fall_lft;  //ground优先级最高，然后是dig，然后是switch
                else if (dig) next_st <= dig_lft;
                else if (bump_left) next_st <= rgt;
                else next_st <=  st;   // ground && !dig && !bump_left 
            3'd1:
                if (!ground) next_st <= fall_rgt;
                else if (dig) next_st <= dig_rgt;
                else if (bump_right) next_st <= lft;
                else next_st <=  st;
            3'd2:
                if (ground) next_st <= lft;
                else next_st <= st;
            3'd3:
                if (ground) next_st <=rgt;
                else next_st <= st;    
            3'd4:
                if (!ground) next_st <= fall_lft;
                else next_st <= st;
            3'd5:
                if (!ground) next_st <= fall_rgt;
                else next_st <= st;
        endcase
    end

    always @(posedge clk or posedge areset) begin //异步复位，继承于lemmings1
        if (areset) 
            st <= lft;
        else
            st <= next_st;
    end

    assign walk_left = st==lft;
    assign walk_right = st==rgt;
    assign aaah = st==fall_lft | st==fall_rgt;
    assign digging = st==dig_lft | st==dig_rgt;

endmodule
