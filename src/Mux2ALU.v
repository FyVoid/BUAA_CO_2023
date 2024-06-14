// This module define operand1 and operand2 for ALU
// operand_type indicates the type of current alu operand
// operand2     operand_type
// Rt           00
// imm          01
// imm(signed)  10
module Mux2ALU(
    input [3:0] operand_type,
    input [31:0] Rs,
    input [31:0] Rt,
    input [15:0] imm,
    output [31:0] operand1,
    output [31:0] operand2
);

    assign operand1 = Rs;
    assign operand2 = operand_type == 2'b0 ? Rt :
                        operand_type == 2'b1 ? {{16{1'b0}}, imm} :
                        operand_type == 2'b10 ? {{16{imm[15]}}, imm} :
                        0; 

endmodule