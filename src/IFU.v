module IFU(
    input clk,
    input reset,
    input enable,
    input jump_flag,
    input [31:0] JumpOffset,
    output [31:0] instruct,
    output [31:0] PCAddr
);

    reg [31:0] PC;
    reg [31:0] IM [0:6095];
    wire [31:0] pc = PC - 32'h00003000;

    initial begin
        $readmemh("code.txt", IM);
        PC = 32'h00003000;
    end

    always @(posedge clk) begin
        if (reset) begin
            PC <= 32'h00003000;
        end else begin
            // if (PC == 32'h000060c4) begin
            //     $display("@%h: $ 12 <= %h", PC, instruct);
            // end
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

    assign instruct = IM[pc[13:2]];

    assign PCAddr = PC;

endmodule