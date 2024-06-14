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
    output [0:2] compare    // pay attention to [0:2]
);

    reg [31:0] result;

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
        endcase
    end

    assign ALUOut = result;
    assign compare = {{operand1 > operand2}, {operand1 == operand2}, {operand1 < operand2}};

endmodule