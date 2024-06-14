module Cmd2Sig(
    input [5:0] command,
    output reg [3:0] ALUop,
    output reg [1:0] instruct_type,
    output reg [3:0] operand_type,
    output reg [3:0] GRF_write,
    output reg [3:0] mem_write,   // important
    output reg reg_write,   // important
    output reg [2:0] jump_signal,   // important
    output reg [3:0] dst_save,
    output reg [3:0] rs_use,    // important
    output reg [3:0] rt_use,    // important
    output reg [3:0] dst_type   // important
);

    always @(*) begin
        case (command)
            // nop
            1'b0: begin
                ALUop = 0;
                instruct_type = 0;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 0;
                rs_use = 4;
                rt_use = 4;
                dst_type = 3;
            end
            // add
            1'b1: begin
                ALUop = 1'b0;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 0;
            end
            // sub
            2'b10: begin
                ALUop = 1'b1;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 0;
            end
            // ori
            2'b11: begin
                ALUop = 2'b10;
                instruct_type = 1'b1;
                operand_type = 1;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 4;
                dst_type = 1;
            end
            // lw
            3'b100: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 2'b10;
                GRF_write = 1'b1;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 4;
                rs_use = 1;
                rt_use = 4;
                dst_type = 1;
            end
            // sw
            3'b101: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 2'b10;
                GRF_write = 0;
                mem_write = 4'b1111;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 0;
                rs_use = 1;
                rt_use = 1;
                dst_type = 2'b11;
            end
            // beq
            3'b110: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 1'b1;
                dst_save = 0;
                rs_use = 0;
                rt_use = 0;
                dst_type = 3;
            end
            // jal
            3'b111: begin
                ALUop = 0;
                instruct_type = 2'b10;
                operand_type = 0;
                GRF_write = 2'b10;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 2'b10;
                dst_save = 1;
                rs_use = 4;
                rt_use = 4;
                dst_type = 2;
            end
            // jr
            4'b1000: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 2'b11;
                dst_save = 0;
                rs_use = 0;
                rt_use = 4;
                dst_type = 3;
            end
            // lui
            4'b1001: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 0;
                GRF_write = 2'b11;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 1;
                rt_use = 4;
                rs_use = 4;
                dst_type = 1;
            end
            // slt
            4'b1010: begin
                ALUop = 4'b101;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 0;
            end
            // sltu
            4'b1011: begin
                ALUop = 4'b110;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 0;
            end
            // addi
            4'b1100: begin
                ALUop = 1'b0;
                instruct_type = 1'b1;
                operand_type = 2;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 4;
                dst_type = 1;
            end
            // andi
            4'b1101: begin
                ALUop = 4'b111;
                instruct_type = 1'b1;
                operand_type = 1;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 4;
                dst_type = 1;
            end
            // lb
            4'b1110: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 2'b10;
                GRF_write = 3'b110;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 4;
                rs_use = 1;
                rt_use = 4;
                dst_type = 1;
            end
            // lh
            4'b1111: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 2'b10;
                GRF_write = 3'b111;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 4;
                rs_use = 1;
                rt_use = 4;
                dst_type = 1;
            end
            // sb
            5'b10000: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 2'b10;
                GRF_write = 0;
                mem_write = 4'b0001;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 0;
                rs_use = 1;
                rt_use = 1;
                dst_type = 2'b11;
            end
            // sh
            5'b10001: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 2'b10;
                GRF_write = 0;
                mem_write = 4'b0011;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 0;
                rs_use = 1;
                rt_use = 1;
                dst_type = 2'b11;
            end
            // mult
            5'b10010: begin
                ALUop = 2'b11;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 2'b11;
            end
            // multu
            5'b10011: begin
                ALUop = 4'b1000;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 2'b11;
            end
            // div
            5'b10100: begin
                ALUop = 4'b100;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 2'b11;
            end
            // divu
            5'b10101: begin
                ALUop = 4'b1001;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 2'b11;
            end
            // mfhi
            5'b10110: begin
                ALUop = 0;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 3'b100;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 4;
                rt_use = 4;
                dst_type = 1'b0;
            end
            // mflo
            5'b10111: begin
                ALUop = 0;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 3'b101;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 4;
                rt_use = 4;
                dst_type = 1'b0;
            end
            // mthi
            5'b11000: begin
                ALUop = 4'b1010;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 4;
                dst_type = 3;
            end
            // mtlo
            5'b11001: begin
                ALUop = 4'b1011;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 4;
                dst_type = 3;
            end
            // bne
            5'b11010: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 3'b100;
                dst_save = 0;
                rs_use = 0;
                rt_use = 0;
                dst_type = 3;
            end
            // and
            5'b11011: begin
                ALUop = 4'b111;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 0;
            end
            // or
            5'b11100: begin
                ALUop = 4'b10;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 1;
                rt_use = 1;
                dst_type = 0;
            end
            // mfc0
            5'b11101: begin
                ALUop = 0;
                instruct_type = 1'b1;
                operand_type = 0;
                GRF_write = 4'b1001;
                mem_write = 0;
                reg_write = 1;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 4;
                rt_use = 4;
                dst_type = 1'b1;
            end
            // mtc0
            5'b11110: begin
                ALUop = 4'b1100;
                instruct_type = 1'b0;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 4;
                rt_use = 1;
                dst_type = 3;
            end
            // eret
            5'b11111: begin
                ALUop = 0;
                instruct_type = 0;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 3'b101;
                dst_save = 0;
                rs_use = 4;
                rt_use = 4;
                dst_type = 3;
            end
            // syscall
            6'b100000: begin
                ALUop = 0;
                instruct_type = 2'b11;
                operand_type = 0;
                GRF_write = 1'b0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 3;
                rs_use = 4;
                rt_use = 4;
                dst_type = 3;
            end
            // error
            6'b111111: begin
                ALUop = 0;
                instruct_type = 0;
                operand_type = 0;
                GRF_write = 0;
                mem_write = 0;
                reg_write = 0;
                jump_signal = 0;
                dst_save = 0;
                rs_use = 4;
                rt_use = 4;
                dst_type = 3;
            end
        endcase
    end

endmodule