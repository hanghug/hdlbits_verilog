// synthesis verilog_input_version verilog_2001
module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up  
);

    always @(*) begin
        {up,down,left,right} = 4'b0;
              // 先预处理，这样就不用因为没分配完写default了
        case (scancode) 
            16'he06b: left = 1'b1;
            16'he072: down = 1'b1;
            16'he074: right = 1'b1;
            16'he075: up = 1'b1;
        endcase    
    end

endmodule
