// 
// Generate a clock with a specific divider
//
module clk_module #(parameter DIVIDER=12000000) (
    input           clk_in, 
    output          clk_out
);

    reg [31:0] counter;

    initial begin
        counter <= 0;
    end

    assign clk_out = counter < (DIVIDER / 2) ? 1 : 0;

    always @(posedge clk_in) begin
        counter <= counter + 1;
        if (counter >= DIVIDER) counter <= 0;
    end

endmodule