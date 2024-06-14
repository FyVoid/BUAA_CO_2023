module Mux_GRF_W(
    input [3:0] GRF_write,
    input [31:0] ALUOut,
    input [31:0] MemOut,
    input [31:0] PCAddr,
    input [15:0] imm,
    input [31:0] hi,
    input [31:0] lo,
    output reg [31:0] out
);

    reg [1:0] byte;

    always @(*) begin
        case (GRF_write)
            1'b0: begin
                out = ALUOut;
            end
            1'b1: begin
                out = MemOut;
            end
            2'b10: begin
                out = PCAddr + 8;
            end
            3'b11: begin
                out = {imm, {16{1'b0}}};
            end
            3'b100: begin
                out = hi;
            end
            3'b101: begin
                out = lo;
            end
            3'b110: begin
                byte = ALUOut[1:0];
                if (byte == 0) out = {{24{MemOut[7]}}, MemOut[7:0]};
                else if (byte == 1) out = {{24{MemOut[15]}}, MemOut[15:8]};
                else if (byte == 2) out = {{24{MemOut[23]}}, MemOut[23:16]};
                else out = {{24{MemOut[31]}}, MemOut[31:24]};
            end
            3'b111: begin
                byte = ALUOut[1:0];
                if (byte == 0) out = {{16{MemOut[15]}}, MemOut[15:0]};
                else out = {{31{MemOut[31]}}, MemOut[31:16]};
            end
        endcase
    end

    // assign out = GRF_write == 1'b0 ? ALUOut :
    //                 GRF_write == 1'b1 ? MemOut :
    //                 GRF_write == 2'b10 ? PCAddr + 8 :
    //                 GRF_write == 2'b11 ? {imm, {16{1'b0}}} :
    //                 GRF_write == 3'b100 ? hi :
    //                 GRF_write == 3'b101 ? lo :
    //                 GRF_write == 3'b110 ? MemOut
    //                 0;

endmodule