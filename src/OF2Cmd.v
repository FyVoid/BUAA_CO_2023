// analyse command type from op and func
module OF2Cmd(
    input [5:0] op,
    input [5:0] func,
    output reg [4:0] command
);

    always @(*) begin
        // add
        if (op == 6'b000000 & func == 6'b100000) begin
            command = 1;
        end
        // sub
        else if (op == 6'b000000 & func == 6'b100010) begin
            command = 2;
        end
        // ori
        else if (op == 6'b001101) begin
            command = 3;
        end
        // lw
        else if (op == 6'b100011) begin
            command = 4;
        end
        // sw
        else if (op == 6'b101011) begin
            command = 5;
        end
        // beq
        else if (op == 6'b000100) begin
            command = 6;
        end
        // jal
        else if (op == 6'b000011) begin
            command = 7;
        end        
        // jr
        else if (op == 6'b000000 & func == 6'b001000) begin
            command = 8;
        end
        // lui
        else if (op == 6'b001111) begin
            command = 9;
        end
        // nop
        else begin
            command = 0;
        end
    end

endmodule