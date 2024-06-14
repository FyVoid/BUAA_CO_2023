module Mux2CP0(
    input Exc_in,
    input [4:0] ExcCode_in,
    output reg Exc_out,
    output reg [4:0] ExcCode_out,
    input [31:0] ALUOut,
    input [3:0] GRF_write,
    input reg_write,
    input [3:0] mem_write
);

    always @(*) begin
        if (Exc_in) begin
            Exc_out = Exc_in;
            ExcCode_out = ExcCode_in;
        end else begin
            if (reg_write) begin
                if (GRF_write == 1'b1 || GRF_write == 3'b110 || GRF_write == 3'b111) begin
                    if (~(
                            (ALUOut >= 0 && ALUOut <= 32'h00002fff)
                            || (ALUOut >= 32'h00007f00 && ALUOut <= 32'h00007f08)
                            || (ALUOut >= 32'h00007f10 && ALUOut <= 32'h00007f18)
                            || (ALUOut == 32'h00007f20)
                            )) 
                        begin
                            Exc_out = 1;
                            ExcCode_out = 4;
                    end
                    // lw
                    else if (GRF_write == 1'b1) begin
                        if (ALUOut % 4 != 0) begin
                            Exc_out = 1;
                            ExcCode_out = 4;
                        end
                        else if (ALUOut == 32'h00002fff) begin
                            Exc_out = 1;
                            ExcCode_out = 4;
                        end
                        else begin
                            Exc_out = Exc_in;
                            ExcCode_out = ExcCode_in;
                        end
                    end
                    // lh
                    else if (GRF_write == 3'b111) begin
                        if (ALUOut % 2 != 0) begin
                            Exc_out = 1;
                            ExcCode_out = 4;
                        end 
                        else if (ALUOut == 32'h00002fff) begin
                            Exc_out = 1;
                            ExcCode_out = 4;
                        end
                        else if (
                            (ALUOut >= 32'h00007f00 && ALUOut <= 32'h00007f08)
                            || (ALUOut >= 32'h00007f10 && ALUOut <= 32'h00007f18)
                        ) begin
                            Exc_out = 1;
                            ExcCode_out = 4;
                        end
                        else begin
                            Exc_out = Exc_in;
                            ExcCode_out = ExcCode_in;
                        end
                    end
                    // lb
                    else if (GRF_write == 3'b110) begin
                        if (
                            (ALUOut >= 32'h00007f00 && ALUOut <= 32'h00007f08)
                            || (ALUOut >= 32'h00007f10 && ALUOut <= 32'h00007f18)
                        ) begin
                            Exc_out = 1;
                            ExcCode_out = 4;
                        end
                        else begin
                            Exc_out = Exc_in;
                            ExcCode_out = ExcCode_in;
                        end
                    end
                end else begin
                    Exc_out = Exc_in;
                    ExcCode_out = ExcCode_in;
                end
            end else if (mem_write != 0) begin
                if (~(
                            (ALUOut >= 0 && ALUOut <= 32'h00002fff)
                            || (ALUOut >= 32'h00007f00 && ALUOut <= 32'h00007f04)   // cant write COUNT
                            || (ALUOut >= 32'h00007f10 && ALUOut <= 32'h00007f14)   // in counter
                            || (ALUOut == 32'h00007f20)
                            )) 
                        begin
                            Exc_out = 1;
                            ExcCode_out = 5;
                    end
                else begin
                    // sw
                    if (mem_write == 4'b1111) begin
                        if (ALUOut % 4 != 0) begin
                            Exc_out = 1;
                            ExcCode_out = 5;
                        end 
                        else if (ALUOut == 32'h00002fff) begin
                            Exc_out = 1;
                            ExcCode_out = 5;
                        end else begin
                            Exc_out = Exc_in;
                            ExcCode_out = ExcCode_in;
                        end
                    end
                    // sh
                    else if (mem_write == 4'b0011) begin
                        if (ALUOut % 2 != 0) begin
                            Exc_out = 1;
                            ExcCode_out = 5;
                        end
                        else if (
                            (ALUOut >= 32'h00007f00 && ALUOut <= 32'h00007f08)
                            || (ALUOut >= 32'h00007f10 && ALUOut <= 32'h00007f18)
                        ) begin
                            Exc_out = 1;
                            ExcCode_out = 5;
                        end
                        else if (ALUOut == 32'h00002fff) begin
                            Exc_out = 1;
                            ExcCode_out = 5;
                        end
                        else begin
                            Exc_out = Exc_in;
                            ExcCode_out = ExcCode_in;
                        end
                    end
                    // sb
                    else if (mem_write == 4'b0001) begin
                        if (
                            (ALUOut >= 32'h00007f00 && ALUOut <= 32'h00007f08)
                            || (ALUOut >= 32'h00007f10 && ALUOut <= 32'h00007f18)
                        ) begin
                            Exc_out = 1;
                            ExcCode_out = 5;
                        end else begin
                            Exc_out = Exc_in;
                            ExcCode_out = ExcCode_in;
                        end
                    end
                end
            end else begin
                Exc_out = Exc_in;
                ExcCode_out = ExcCode_in;
            end
        end
    end

endmodule