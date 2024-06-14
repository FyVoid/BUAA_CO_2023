module DM(
    input clk,
    input reset,
    input [31:0] Addr,
    input [31:0] WriteData,
    input [3:0] mem_write,
    input [31:0] PC,
    output [31:0] DMOut
);

    reg [31:0] Memory [0:3071];
    integer i;

    always @(posedge clk) begin: dm_for
        if (reset) begin
            for (i = 0; i < 3072; i = i + 1) begin
                Memory[i] <= 32'b0;
            end
        end else begin
            // address isn't validated here
            if (|mem_write) begin
                $display("%d@%h: *%h <= %h", $time, PC, Addr, WriteData);
                Memory[Addr >> 2] <= WriteData;
            end
        end
    end

    assign DMOut = Memory[Addr >> 2];

endmodule