module IFU(
    input clk,
    input reset,
    input jump_flag,
    input [31:0] JumpOffset,
    output [31:0] instruct,
    output [31:0] PCAddr
);

    reg [31:0] PC;
    reg [31:0] IM [0:4095];

    initial begin
        $readmemh("code.txt", IM);
        PC = 32'h00003000;
    end

    always @(posedge clk) begin
        if (reset) begin
            PC <= 32'h00003000;
        end else begin
            if (jump_flag) begin
                PC <= JumpOffset;
            end else begin
                PC <= PC + 32'h4;
            end
        end
    end

    assign instruct = IM[(PC - 32'h00003000) >> 2];

    assign PCAddr = PC;

endmodule