module Mux2GRF_ID(
    input [4:0] RsAddr,
    input [4:0] RtAddr,
    output [4:0] ReadAddr1,
    output [4:0] ReadAddr2
);

    assign ReadAddr1 = RsAddr;
    assign ReadAddr2 = RtAddr;

endmodule