module Mux_GRF_W(
    input [3:0] GRF_write,
    input [31:0] ALUOut,
    input [31:0] MemOut,
    input [31:0] PCAddr,
    input [15:0] imm,
    output [31:0] out
);

    assign out = GRF_write == 1'b0 ? ALUOut :
                    GRF_write == 1'b1 ? MemOut :
                    GRF_write == 2'b10 ? PCAddr + 8 :
                    GRF_write == 2'b11 ? {imm, {16{1'b0}}} :
                    0;

endmodule