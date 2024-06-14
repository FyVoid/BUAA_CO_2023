module Comparer(
    input [31:0] operand1,
    input [31:0] operand2,
    output [0:2] compare
);

    assign compare = {{operand1 > operand2}, {operand1 == operand2}, {operand1 < operand2}};

endmodule