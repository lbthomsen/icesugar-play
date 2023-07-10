//
// Run PWM on the R, G, and B leds

module pwm (
    input           CLK, 
    output          LED_R, 
    output          LED_G, 
    output          LED_B
);

    parameter NUM_STEPS = 4;

    wire led_clk;
    wire pwm_clk;

    reg [7:0] value_r;
    reg [7:0] value_g;
    reg [7:0] value_b;

    reg [7:0] step;

    wire [23:0] value_single;
    reg [23:0] value [0:NUM_STEPS - 1];

    assign value_single = value[step];

    clk_module #(.DIVIDER(12000000)) clk_1_s (
        .clk_in(CLK), 
        .clk_out(led_clk)
    );

    clk_module #(.DIVIDER(1200)) clk_1_ms (
        .clk_in(CLK), 
        .clk_out(pwm_clk)
    );

    pwm_module pwmR (
        .clk(pwm_clk), 
        .value(value_single[23:16]),
        .out(LED_R)
    );

    pwm_module pwmG (
        .clk(pwm_clk), 
        .value(value_single[15:8]), 
        .out(LED_G)
    );

    pwm_module pwmB (
        .clk(pwm_clk), 
        .value(value_single[7:0]), 
        .out(LED_B)
    );

    initial begin
        step = 0;
        value[0] = 24'h000000;
        value[1] = 24'h050000;
        value[2] = 24'h000500;
        value[3] = 24'h000005;
    end

    always @(posedge led_clk) begin
        step = step + 1;
        if (step >= NUM_STEPS) step = 0;
        //value_single <= value[step];
    end

endmodule