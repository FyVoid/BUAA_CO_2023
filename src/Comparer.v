module Comparer(
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] compare
);

    always @(*) begin
        compare[0] = operand1 > operand2;
        compare[1] = operand1 == operand2;
        compare[2] = operand1 < operand2;
    end

    // assign compare = {{operand1 > operand2}, {operand1 == operand2}, {operand1 < operand2}};

endmodule