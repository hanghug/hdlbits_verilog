module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    // parameter LEFT=0, RIGHT=1, ...
    parameter lft = 1'b0, rgt = 1'b1;
    reg st, next_st;  

    always @(*) begin
        // State transition logic
        case (st) 
            1'b0:
                if (bump_left) next_st = rgt;
                else next_st = st;
            2'b1:
                if (bump_right) next_st = lft;
                else next_st = st;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) 
            st <= lft;
        else
            st <= next_st;
    end

    // Output logic
    // assign walk_left = (state == ...);
    // assign walk_right = (state == ...);
    assign walk_left = st==lft;
    assign walk_right = ~walk_left;

endmodule
