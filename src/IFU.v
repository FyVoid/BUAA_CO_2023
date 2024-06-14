module IFU(
    input clk,
    input reset,
    input enable,
    input jump_flag,
    input [31:0] JumpOffset,
    output [31:0] PCAddr
);

    reg [31:0] PC;
    wire [31:0] pc = PC - 32'h00003000;

    initial begin
        PC = 32'h00003000;
    end

    always @(posedge clk) begin
        if (reset) begin
            PC <= 32'h00003000;
        end else begin
            if (enable) begin
                if (jump_flag) begin
                    PC <= JumpOffset;
                end else begin
                    PC <= PC + 32'h4;
                end
            end else begin
                PC <= PC;
            end
        end
    end

    assign PCAddr = PC;

endmodule