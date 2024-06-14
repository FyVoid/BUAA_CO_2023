module IDiv(
    input [31:0] instruct,
    output [5:0] op,
    output [4:0] RsAddr,
    output [4:0] RtAddr,
    output [4:0] RdAddr,
    output [4:0] Shamt,
    output [5:0] func,
    output [15:0] addr16,
    output [25:0] addr26
);

    assign op = instruct[31:26];
    assign RsAddr = instruct[25:21];
    assign RtAddr = instruct[20:16];
    assign RdAddr = instruct[15:11];
    assign Shamt = instruct[10:6];
    assign func = instruct[5:0];
    assign addr16 = instruct[15:0];
    assign addr26 = instruct[25:0];

endmodule