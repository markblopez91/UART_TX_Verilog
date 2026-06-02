module uart_tx(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);

parameter CLKS_PER_BIT = 434;

reg [15:0] clk_count;
reg [3:0] bit_index;
reg [9:0] tx_shift;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        tx <= 1'b1;
        tx_busy <= 1'b0;
        clk_count <= 0;
        bit_index <= 0;
        tx_shift <= 10'b1111111111;
    end
    else
    begin
        if (tx_start && !tx_busy)
        begin
            tx_busy <= 1'b1;
            tx_shift <= {1'b1, tx_data, 1'b0};
            bit_index <= 0;
            clk_count <= 0;
        end
        else if (tx_busy)
        begin
            if (clk_count < CLKS_PER_BIT - 1)
            begin
                clk_count <= clk_count + 1;
            end
            else
            begin
                clk_count <= 0;

                tx <= tx_shift[0];
                tx_shift <= {1'b1, tx_shift[9:1]};

                if (bit_index < 9)
                begin
                    bit_index <= bit_index + 1;
                end
                else
                begin
                    tx_busy <= 1'b0;
                    tx <= 1'b1;
                end
            end
        end
    end
end

endmodule