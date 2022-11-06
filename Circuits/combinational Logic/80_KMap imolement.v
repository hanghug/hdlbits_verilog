module top_module (
    input c,
    input d,
    output [3:0] mux_in
); 
	
 //   always @(*) begin
 //       case({c,d}) 
 //           2'b00: mux_in = 4'b0100;
 //       	  2'b01: mux_in = 4'b0001;
 //           2'b11: mux_in = 4'b1001;
 //           2'b10: mux_in = 4'b0101;
  //      endcase  
  //  end
    
    assign mux_in[0] = c ? 1'b1: (d ? 1'b1 : 1'b0);
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = d ? 1'b0 : 1'b1;
    assign mux_in[3] = (c && d) ? 1'b1 : 1'b0;
    
endmodule
