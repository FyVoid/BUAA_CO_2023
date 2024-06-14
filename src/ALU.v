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
    output [31:0] compare,    // pay attention to [0:2]
    output reg overflow
);

    reg [32:0] o1;
    reg [32:0] o2;
    reg [32:0] rst;
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
    // 101              <(signed)
    // 110              <
    // 111              &

    always @(*) begin
        o1 = {operand1[31], operand1};
        o2 = {operand2[31], operand2};
        case (ALUop)
            4'b0: begin
                rst = o1 + o2;
                if (rst[32] != rst[31]) begin
                    overflow = 1;
                end else begin
                    overflow = 0;
                end
                result = operand1 + operand2;
            end
            4'b1: begin
                rst = o1 - o2;
                if (rst[32] != rst[31]) begin
                    overflow = 1;
                end else begin
                    overflow = 0;
                end
                result = operand1 - operand2;
            end
            4'b10: begin
                result = operand1 | operand2;
                overflow = 0;
            end
            4'b101: begin
                result = {{31{1'b0}}, $signed(operand1) < $signed(operand2)};
                overflow = 0;
            end
            4'b110: begin
                result = {{31{1'b0}}, operand1 < operand2};
                overflow = 0;
            end
            4'b111: begin
                result = operand1 & operand2;
                overflow = 0;
            end
            default: begin
                overflow = 0;
            end
        endcase
    end

    assign ALUOut = result;

endmodule