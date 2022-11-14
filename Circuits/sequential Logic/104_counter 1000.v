module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //
    // 1KHz到1Hz的降频，时钟周期1s，即高电平0.5s 低电平0.5s。
    // 非均匀分频，0计数到999，最后信号变一次即可，只维持一拍高电平。 

    wire[3:0] one,ten,hundred;

    assign c_enable[0] = 1'b1;        //一直工作
    assign c_enable[1] = one==4'd9;   //当个位计数到9时工作一次，最大计数99
    assign c_enable[2] = ten==4'd9&&one==4'd9; //当个位计数到9，十位计数到9时工作一次，最大计数999

    assign OneHertz = (hundred==4'd9 && ten==4'd9 && one==4'd9);  //计数到999时高电平一拍

    bcdcount counter0 (clk, reset, c_enable[0] , one);
    bcdcount counter1 (clk, reset, c_enable[1] , ten);
    bcdcount counter2 (clk, reset, c_enable[2] , hundred);

endmodule
