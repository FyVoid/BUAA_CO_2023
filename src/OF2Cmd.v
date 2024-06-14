// analyse command type from op and func
module OF2Cmd(
    input [5:0] op,
    input [5:0] func,
    output reg [5:0] command
);

    always @(*) begin
        // add
        if (op == 6'b000000 && func == 6'b100000) begin
            command = 1'b1;
        end
        // sub
        else if (op == 6'b000000 && func == 6'b100010) begin
            command = 2'b10;
        end
        // ori
        else if (op == 6'b001101) begin
            command = 2'b11;
        end
        // lw
        else if (op == 6'b100011) begin
            command = 3'b100;
        end
        // sw
        else if (op == 6'b101011) begin
            command = 3'b101;
        end
        // beq
        else if (op == 6'b000100) begin
            command = 3'b110;
        end
        // jal
        else if (op == 6'b000011) begin
            command = 3'b111;
        end        
        // jr
        else if (op == 6'b000000 && func == 6'b001000) begin
            command = 4'b1000;
        end
        // lui
        else if (op == 6'b001111) begin
            command = 4'b1001;
        end
        // slt
        else if (op == 6'b000000 && func == 6'b101010) begin
            command = 4'b1010;
        end
        // sltu
        else if (op == 6'b000000 && func == 6'b101011) begin
            command = 4'b1011;
        end
        // addi
        else if (op == 6'b001000) begin
            command = 4'b1100;
        end
        // andi
        else if (op == 6'b001100) begin
            command = 4'b1101;
        end
        // lb
        else if (op == 6'b100000) begin
            command = 4'b1110;
        end
        // lh
        else if (op == 6'b100001) begin
            command = 4'b1111;
        end
        // sb
        else if (op == 6'b101000) begin
            command = 5'b10000;
        end
        // sh
        else if (op == 6'b101001) begin
            command = 5'b10001;
        end
        // mult
        else if (op == 6'b000000 && func == 6'b011000) begin
            command = 5'b10010;
        end
        // multu
        else if (op == 6'b000000 && func == 6'b011001) begin
            command = 5'b10011;
        end
        // div
        else if (op == 6'b000000 && func == 6'b011010) begin
            command = 5'b10100;
        end
        // divu
        else if (op == 6'b000000 && func == 6'b011011) begin
            command = 5'b10101;
        end
        // mfhi
        else if (op == 6'b000000 && func == 6'b010000) begin
            command = 5'b10110;
        end
        // mflo
        else if (op == 6'b000000 && func == 6'b010010) begin
            command = 5'b10111;
        end
        // mthi
        else if (op == 6'b000000 && func == 6'b010001) begin
            command = 5'b11000;
        end
        // mtlo
        else if (op == 6'b000000 && func == 6'b010011) begin
            command = 5'b11001;
        end
        // bne
        else if (op == 6'b000101) begin
            command = 5'b11010;
        end
        // and
        else if (op == 6'b000000 && func == 6'b100100) begin
            command = 5'b11011;
        end
        // or
        else if (op == 6'b000000 && func == 6'b100101) begin
            command = 5'b11100;
        end
        // nop
        else begin
            command = 0;
        end
    end

endmodule