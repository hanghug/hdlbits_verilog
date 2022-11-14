module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);

    assign next_state[0] = ~in & ((|state[4:0]) | (|state[9:7]));
    assign next_state[1] = in & (state[0]| (|state[9:8]));
    assign next_state[2] = in & state[1];
    assign next_state[3] = in & state[2];
    assign next_state[4] = in & state[3];
    assign next_state[5] = in & state[4];
    assign next_state[6] = in & state[5];
    assign next_state[7] = in & (|state[7:6]);
    assign next_state[8] = ~in & state[5];
    assign next_state[9] = ~in & state[6];

    assign out1 = |state[9:8];
    assign out2 = state[9] | state[7];


    // parameter 只能给定义常量吧应该 这样写报错。
    //parameter S0=state[4'd0], S1=state[4'd1],S2=state[4'd2],S3=state[4'd3];
    //parameter S4=state[4'd4], S5=state[4'd5],S6=state[4'd6],S7=state[4'd7];
   // parameter S8=state[4'd8], S9=state[4'd9];

    // assign next_state[0] = ~in & (S0|S1|S2|S3|S4|S7|S8|S9);
    // assign next_state[1] = in & (S0|S8|S9);
    // assign next_state[2] = in & S1;
    // assign next_state[3] = in & S2;
    // assign next_state[4] = in & S3;
    // assign next_state[5] = in & S4;
    // assign next_state[6] = in & S5;
    // assign next_state[7] = in & (S6|S7);
    // assign next_state[8] = ~in & S5;
    // assign next_state[9] = ~in & S6;

    // assign out1 = S8 | S9;
    // assign out2 = S7 | S9;
endmodule
