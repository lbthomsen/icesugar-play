//plug pmod-led on PMOD2 

module i2cpwm (
    input           clk, 
    output [7:0]    leds,
    input           mosi, 
    output          miso, 
    input           sck, 
    input           cs, 
    inout           scl, 
    inout           sda
);
      
    wire led_clk;
    wire pwm_clk;

    reg [7:0] value[8];

    assign led = led_clk;

    initial begin
        value[0] = 1;
        value[1] = 20;
        value[2] = 40;
        value[3] = 60;
        value[4] = 80;
        value[5] = 100;
        value[6] = 200;
        value[7] = 255; 
    end

    clk_module #(.DIVIDER(12000000)) clk_1_s (
        .clk_in(clk), 
        .clk_out(led_clk)
    );

    clk_module #(.DIVIDER(1200)) clk_1_ms (
        .clk_in(clk), 
        .clk_out(pwm_clk)
    );

    i2c_slave_module i2c_slave (
        .clk(scl), 
        .sda(sda)
    );

    pwm_module pwm0 (
        .clk(pwm_clk), 
        .value(value[0]), 
        .out(leds[0])
    );

    pwm_module pwm1 (
        .clk(pwm_clk), 
        .value(value[1]), 
        .out(leds[1])
    );

    pwm_module pwm2 (
        .clk(pwm_clk), 
        .value(value[2]), 
        .out(leds[2])
    );

    pwm_module pwm3 (
        .clk(pwm_clk), 
        .value(value[3]), 
        .out(leds[3])
    );

    pwm_module pwm4 (
        .clk(pwm_clk), 
        .value(value[4]), 
        .out(leds[4])
    );

    pwm_module pwm5 (
        .clk(pwm_clk), 
        .value(value[5]), 
        .out(leds[5])
    );

    pwm_module pwm6 (
        .clk(pwm_clk), 
        .value(value[6]), 
        .out(leds[6])
    );

    pwm_module pwm7 (
        .clk(pwm_clk), 
        .value(value[7]), 
        .out(leds[7])
    );

endmodule