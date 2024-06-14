// GRF_write indicate what to be stored in GRF
// GRF_write    data source
// 00           ALUOut
// 01           MemOut
// 10           PCReturnAddr
// 11           luiResult
// 100          hi
// 101          lo
module Mux2GRF_WB(
    input [1:0] instruct_type,
    input [3:0] GRF_write,
    input [4:0] RsAddr,
    input [4:0] RtAddr,
    input [4:0] RdAddr,
    input [31:0] MemOut,
    input [31:0] ALUOut,
    input [31:0] PCAddr,  // save PC address for jal, raw PC address should + 8 first
    input [15:0] imm,   // imm from lui
    input [31:0] hi,
    input [31:0] lo,
    output [4:0] WriteAddr,
    output [31:0] RegData
);

    Mux_GRF_W mux_grf_w(
        .GRF_write(GRF_write),
        .ALUOut(ALUOut),
        .MemOut(MemOut),
        .PCAddr(PCAddr),
        .imm(imm),
        .hi(hi),
        .lo(lo),
        .out(RegData)
    );

    assign WriteAddr = instruct_type == 1'b0 ? RdAddr :
                        instruct_type == 1'b1 ? RtAddr :
                        instruct_type == 2'b10 ? 31 :
                        0;

    // assign RegData = GRF_write == 1'b0 ? ALUOut :
    //                 GRF_write == 1'b1 ? MemOut :
    //                 GRF_write == 2'b10 ? PCAddr + 8 :
    //                 GRF_write == 2'b11 ? {imm, {16{1'b0}}} :
    //                 0;


endmodule