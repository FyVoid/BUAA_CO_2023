// This module define operand1 and operand2 for ALU
// instruct_type indicates the type of current mips instruction
// mips_instruction     instruct_type
// R                    00
// I                    01
// J                    10
module Controller(
    input [5:0] op,
    input [5:0] func,
    input [4:0] RdAddr,
    input [4:0] RtAddr,
    output [3:0] ALUop,
    output [1:0] instruct_type,
    output [3:0] operand_type,
    output [3:0] GRF_write,
    output [3:0] mem_write,   // important
    output reg_write,   // important
    output [2:0] jump_signal,    // important
    output [4:0] dst_addr,
    output [3:0] dst_save,
    output [3:0] rs_use,
    output [3:0] rt_use
);

    wire [5:0] command;
    wire [3:0] dst_type;

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
        .jump_signal(jump_signal),
        .dst_type(dst_type),
        .dst_save(dst_save),
        .rs_use(rs_use),
        .rt_use(rt_use)
    );
    
    // dst_type     dst
    // 00           rd
    // 01           rt
    // 10           ra
    // 11           mem(zero)
    assign dst_addr = dst_type == 1'b0 ? RdAddr :
                        dst_type == 1'b1 ? RtAddr :
                        dst_type == 2'b10 ? 31 :
                        dst_type == 2'b11 ? 0 :
                        0;

endmodule