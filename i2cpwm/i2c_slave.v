module i2c_slave_module (
  input wire clk,
  input wire rst,
  inout wire sda,
  output reg sda_out
);

  reg [7:0] data_reg;
  reg [2:0] state;

  // I2C Slave address
  parameter SLAVE_ADDRESS = 8'hA0;

  // I2C states
  parameter IDLE = 3'b000;
  parameter ADDRESS_MATCH = 3'b001;
  parameter DATA_TRANSFER = 3'b010;
  parameter ACK = 3'b011;

  // I2C clock count
  parameter CLK_COUNT = 8;

  // I2C bit count
  parameter BIT_COUNT = 8;

  // Counter for clock and bit count
  reg [7:0] clk_count;
  reg [2:0] bit_count;

  // I2C bus status
  reg sda_ack;

  // Internal control signals
  wire sda_internal;

  // Assign internal sda output
  assign sda_internal = (state == ADDRESS_MATCH || state == DATA_TRANSFER) ? data_reg[bit_count] : 1'bz;

  // SDA output buffer
  always @(posedge clk) begin
    if (rst) begin
      sda_out <= 1'bz;
    end else begin
      sda_out <= sda_ack ? sda_internal : 1'bz;
    end
  end

  // I2C state machine
  always @(posedge clk) begin
    if (rst) begin
      state <= IDLE;
      sda_ack <= 1'b0;
      clk_count <= 0;
      bit_count <= 0;
      data_reg <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (~sda[0] && sda[1]) begin
            state <= ADDRESS_MATCH;
          end
        end
        ADDRESS_MATCH: begin
          if (clk_count == CLK_COUNT - 1) begin
            clk_count <= 0;
            if (sda[0]) begin
              state <= IDLE;
            end else begin
              if (sda[1:2] == SLAVE_ADDRESS) begin
                sda_ack <= 1'b1;
                state <= DATA_TRANSFER;
              end else begin
                state <= IDLE;
              end
            end
          end else begin
            clk_count <= clk_count + 1;
          end
        end
        DATA_TRANSFER: begin
          if (clk_count == CLK_COUNT - 1) begin
            clk_count <= 0;
            if (bit_count == BIT_COUNT - 1) begin
              state <= ACK;
            end else begin
              bit_count <= bit_count + 1;
            end
          end else begin
            clk_count <= clk_count + 1;
          end
        end
        ACK: begin
          if (clk_count == CLK_COUNT - 1) begin
            clk_count <= 0;
            if (~sda[0]) begin
              sda_ack <= 1'b1;
              if (bit_count == 0) begin
                state <= DATA_TRANSFER;
              end else begin
                state <= ACK;
              end
            end else begin
              sda_ack <= 1'b0;
              state <= IDLE;
            end
          end else begin
            clk_count <= clk_count + 1;
          end
        end
      endcase
    end
  end
endmodule