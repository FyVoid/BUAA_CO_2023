module Cmd2Sig(
    input [4:0] command,
    output reg [3:0] ALUop,
    output reg [1:0] instruct_type,
    output reg [3:0] operand_type,
    output reg [3:0] GRF_write,
    output reg mem_write,   // important
    output reg reg_write,   // important
    output reg [2:0] jump_signal    // important
);

    always @(*) begin
        case (command)
            // nop
            1'b0: begin
                reg_write = 0;
                mem_write = 0;
                jump_signal = 0;
                instruct_type = 0;
            end
            // add
            1'b1: begin
                ALUop = 1'b0;
                instruct_type = 1'b0;
                GRF_write = 1'b0;
                reg_write = 1;
                mem_write = 0;
                jump_signal = 0;
                operand_type = 0;
            end
            // sub
            2'b10: begin
                ALUop = 1'b1;
                instruct_type = 1'b0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                operand_type = 0;
            end
            // ori
            2'b11: begin
                ALUop = 2'b10;
                instruct_type = 1'b1;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                operand_type = 1;
            end
            // lw
            3'b100: begin
                instruct_type = 1'b1;
                GRF_write = 1'b1;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                operand_type = 2'b10;
                ALUop = 0;
            end
            // sw
            3'b101: begin
                instruct_type = 1'b1;
                mem_write = 1;
                reg_write = 0;
                jump_signal = 0;
                operand_type = 2'b10;
                ALUop = 0;
            end
            // beq
            3'b110: begin
                instruct_type = 1'b1;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 1'b1;
                operand_type = 0;
            end
            // jal
            3'b111: begin
                instruct_type = 2'b10;
                mem_write = 0;
                reg_write = 1;
                GRF_write = 2'b10;
                jump_signal = 2'b10;
            end
            // jr
            4'b1000: begin
                instruct_type = 1'b1;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 2'b11;
            end
            // lui
            4'b1001: begin
                instruct_type = 1'b1;
                mem_write = 0;
                reg_write = 1;
                GRF_write = 2'b11;
                jump_signal = 0;
            end
        endcase
    end

endmodule
