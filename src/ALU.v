// compare is the result of operand1 comparing with operand2
// compare      operation
// [0]          o1 > o2
// [1]          o1 == o2
// [2]          o1 < o2
module ALU(
    input [3:0] ALUop,
    input [31:0] operand1,
    input [31:0] operand2,
    output [31:0] ALUOut,
    output [31:0] compare    // pay attention to [0:2]
);

    reg [31:0] result;

    Comparer comparer(
        .operand1(operand1),
        .operand2(operand2),
        .compare(compare)
    );

    // ALUOp            operation
    // 0                +
    // 1                -
    // 10               |
    // 11               *(in MulDiv)
    // 100              /(in MulDiv)
    // 101              <
    // 110              &

    always @(*) begin
        case (ALUop)
            4'b0: begin
                result = operand1 + operand2;
            end
            4'b1: begin
                result = operand1 - operand2;
            end
            4'b10: begin
                result = operand1 | operand2;
            end
            4'b101: begin
                result = {{31{1'b0}}, $signed(operand1) < $signed(operand2)};
            end
            4'b110: begin
                result = {{31{1'b0}}, operand1 < operand2};
            end
            4'b111: begin
                result = operand1 & operand2;
            end
        endcase
    end

    assign ALUOut = result;

endmodule