module blink (
    input wire clk,
    output reg led
);
reg [24:0] counter;

always @(posedge clk) begin
    if (counter == 25'd26_999_999) begin
        led <= ~led;
        counter <= 25'b0;
    end else begin 
        counter <= counter + 1;
    end
end
endmodule

