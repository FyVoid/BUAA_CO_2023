module MuxMul(
    input [3:0] ALUop,
    input [3:0] GRF_write,
    output Mul_flag
);

    assign Mul_flag = ALUop == 4'b1010          // mthi
                        || ALUop == 4'b1011     // mtlo
                        || GRF_write == 3'b100  // mfhi
                        || GRF_write == 3'b101  // mflo
                        ;

endmodule