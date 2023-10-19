module new_clk #(parameter frec=2) (seconds,clk);

output reg seconds = 1'b0;
input clk; 
integer count = 1;


always @(posedge clk)
begin
	 if(count == frec) begin 
        count   <= 1;
        seconds <= ~seconds;
    end else begin
        count   <= count + 1;
    end 
end

endmodule