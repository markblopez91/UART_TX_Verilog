`timescale 1ns / 1ps

module uart_tx_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

uart_tx uut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

// Clock generation
always #5 clk = ~clk;

initial
begin
    // Initialize
    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    // Reset pulse
    #20;
    rst = 0;

    // Send byte
    #20;
    tx_data = 8'hA5;
    tx_start = 1;

    #10;
    tx_start = 0;

    // Wait for transmission
    #100000;

    $stop;
end

endmodule