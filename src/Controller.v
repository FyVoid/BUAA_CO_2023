// This module define operand1 and operand2 for ALU
// instruct_type indicates the type of current mips instruction
// mips_instruction     instruct_type
// R                    00
// I                    01
// J                    10
module Controller(
    input [5:0] op,
    input [5:0] func,
    output [3:0] ALUop,
    output [1:0] instruct_type,
    output [3:0] operand_type,
    output [3:0] GRF_write,
    output mem_write,   // important
    output reg_write,   // important
    output [2:0] jump_signal    // important
);
    wire [4:0] command;

    OF2Cmd of2cmd(
        .op(op),
        .func(func),
        .command(command)
    );

    Cmd2Sig cmd2sig(
        .command(command),
        .ALUop(ALUop),
        .instruct_type(instruct_type),
        .operand_type(operand_type),
        .GRF_write(GRF_write),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .jump_signal(jump_signal)
    );

endmodule