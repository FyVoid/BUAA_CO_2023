// This module isn't actually Mux
module Mux2DM(
    input [31:0] ALUOut,
    input [31:0] Rt,
    output [31:0] DM_WriteData,
    output [31:0] Addr
);

    assign Addr = ALUOut;
    assign DM_WriteData = Rt;

endmodule