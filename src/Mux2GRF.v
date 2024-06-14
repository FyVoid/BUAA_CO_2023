// GRF_write indicate what to be stored in GRF
// GRF_write    data source
// 00           ALUOut
// 01           MemOut
// 10           PCReturnAddr
// 11           luiResult
module Mux2GRF(
    input [1:0] instruct_type,
    input [2:0] jump_signal,
    input [3:0] GRF_write,
    input [4:0] RsAddr,
    input [4:0] RtAddr,
    input [4:0] RdAddr,
    input [31:0] MemOut,
    input [31:0] ALUOut,
    input [31:0] PCAddr,  // save PC address for jal, raw PC address should + 8 first
    input [15:0] imm,   // imm from lui
    output [4:0] WriteAddr,
    output [4:0] ReadAddr1, // Rs
    output [4:0] ReadAddr2, // Rt
    output [31:0] RegData
);

    assign ReadAddr1 = RsAddr;
    assign ReadAddr2 = RtAddr;

    assign WriteAddr = instruct_type == 1'b0 ? RdAddr :
                        instruct_type == 1'b1 ? RtAddr :
                        instruct_type == 2'b10 & jump_signal == 2'b10 ? 31 :
                        0;

    assign RegData = GRF_write == 1'b0 ? ALUOut :
                        GRF_write == 1'b1 ? MemOut :
                        GRF_write == 2'b10 ? PCAddr + 4 :
                        GRF_write == 2'b11 ? {imm, {16{1'b0}}} :
                        0;

endmodule