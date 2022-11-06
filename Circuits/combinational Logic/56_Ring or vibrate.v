module top_module (
    input ring,
    input vibrate_mode,
    output ringer,       // Make sound
    output motor         // Vibrate
);
    //  错误，if esle只能在块中使用
    // if (vibrate_mode) 
    //     assign motor = 1'b1;
    // else 
    //     assign ringer = 1'b0;

    assign ringer = ~vibrate_mode&ring ? 1'b1: 1'b0;
    assign motor = vibrate_mode&ring ? 1'b1: 1'b0;

endmodule
