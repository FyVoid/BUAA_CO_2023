module GRF(
    input reg_write,
    input clk,
    input reset,    // 同步复位
    input [31:0] RegData,
    input [4:0] WriteAddr,
    input [4:0] ReadAddr1,  // Rs
    input [4:0] ReadAddr2,  // Rt
    input [31:0] PC,
    output [31:0] GRFOut1,     // GRF[Rs]
    output [31:0] GRFOut2      // GRF[Rt]
);

    reg [31:0] Regs [31:1];
    integer i;

    always @(negedge clk) begin: grf_for
        if (reset) begin
            for (i = 1; i < 32; i = i + 1) begin
                Regs[i] <= 32'b0;
            end
        end else begin
            if (reg_write) begin
                if (WriteAddr != 0) begin
                    Regs[WriteAddr] <= RegData;
                end
            end
        end
    end

    assign GRFOut1 = ReadAddr1 == 0 ? 0 : Regs[ReadAddr1];
    assign GRFOut2 = ReadAddr2 == 0 ? 0 : Regs[ReadAddr2];

endmodule