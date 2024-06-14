// process of addr26 in this module is not strictly according to reference
module Mux2IFU(
    input [15:0] addr16,
    input [25:0] addr26,
    input [31:0] Rs,
    input [31:0] PC,
    input [2:0] jump_signal, // indicating jump type
    input [31:0] compare,
    output jump_flag,
    output reg [31:0] JumpOffset
);

    assign jump_flag = (jump_signal == 2'b1 && compare[1]) 
            | jump_signal == 2'b10 
            | jump_signal == 2'b11
            | (jump_signal == 3'b100 && compare[1] == 0)
            ;

    always @(*) begin
        // beq
        if (jump_signal == 1'b1 && compare[1]) begin
            JumpOffset = PC + {{14{addr16[15]}}, {addr16}, {2{1'b0}}} + 4;
        end
        // jal
        else if (jump_signal == 2'b10) begin
            JumpOffset = {{4{1'b0}}, addr26, {2{1'b0}}};
        end
        // jr
        else if (jump_signal == 2'b11) begin
            JumpOffset = Rs;
        end
        // bne
        else if (jump_signal == 3'b100 && compare[1] == 0) begin
            JumpOffset = PC + {{14{addr16[15]}}, {addr16}, {2{1'b0}}} + 4;
        end
    end

endmodule