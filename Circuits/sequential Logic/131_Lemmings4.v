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

    parameter  lft = 3'd0, rgt = 3'd1, fall_lft = 3'd2, fall_rgt = 3'd3;
    parameter dig_lft = 3'd4,  dig_rgt = 3'd5, death1 = 3'd6, death2 = 3'd7;
    // death1判断它将要死亡了，此时正在下落；death2说明地面出现了，它摔死了已经。
    reg [3:0] st,next_st;  
    reg [4:0] counter;

    always @(*) begin
        case(st)
            3'd0: 
                if (!ground) next_st = fall_lft;  //ground优先级最高，然后是dig，然后是switch
                else if (dig) next_st = dig_lft;
                else if (bump_left) next_st = rgt;
                else next_st =  st;   // ground && !dig && !bump_left 
            3'd1:
                if (!ground) next_st = fall_rgt;
                else if (dig) next_st = dig_rgt;
                else if (bump_right) next_st = lft;
                else next_st =  st;
            3'd2: //在它落地之前进行判断，是继续掉落还是死亡，最多持续19拍，20拍就要死。
                if (!ground) begin
                   if  (counter <= 5'd19 - 5'd1) next_st = st;
                   else next_st = death1;
                end  //可以成功落地
                else next_st = lft;
            3'd3:
                if (!ground) begin
                   if  (counter <= 5'd19 - 5'd1) next_st = st;
                   else next_st = death1;
                end
                else next_st = rgt;   
            3'd4:
                if (!ground) next_st = fall_lft;
                else next_st = st;
            3'd5:
                if (!ground) next_st = fall_rgt;
                else next_st = st;
            3'd6:
                if (ground) next_st = death2;
                else next_st = st;
            3'd7:
                next_st <= st;    
        endcase
    end

    always @(posedge clk or posedge areset) begin //异步复位，继承于lemmings1
        if (areset) 
            st <= lft;
        else
            st <= next_st;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 5'd0;
        end
        else if (st==fall_lft || st==fall_rgt) begin  //next_st==fall_lft || next_st==fall_rgt对应的是5'd19,33 39行要对应改。
            counter <= counter + 1'd1;
        end
        else 
            counter <= 5'd0;
    end

    assign walk_left = st==lft;
    assign walk_right = st==rgt;
    assign aaah = st==fall_lft | st==fall_rgt | st==death1;
    assign digging = st==dig_lft | st==dig_rgt;
    // death2 状态下上述一个状态也不符，全为0。

endmodule
