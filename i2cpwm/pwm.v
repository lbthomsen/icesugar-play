// 
// Single PWM Line
//
module pwm_module (
    input               clk, 
    input        [7:0]  value, 
    output              out
);

    reg [7:0] counter;

    assign out = counter < value ? 0 : 1;

    initial begin
        counter = 0;
    end

    always @(posedge clk) begin
        counter <= counter + 1;
    end

endmodule