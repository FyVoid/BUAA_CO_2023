module OverflowMux(
    input Exc_in,
    input [4:0] ExcCode_in,
    output reg Exc_out,
    output reg [4:0] ExcCode_out,
    input overflow,
    input reg_write,
    input [3:0] GRF_write,
    input [3:0] mem_write
);

    always @(*) begin
        if (Exc_in) begin
            Exc_out = Exc_in;
            ExcCode_out = ExcCode_in;
        end else begin
            if (overflow) begin
                if (GRF_write == 1 
                || GRF_write == 3'b110 
                || GRF_write == 3'b111
                ) begin
                    Exc_out = 1;
                    ExcCode_out = 4;
                end
                else if (mem_write != 0) begin
                    Exc_out = 1;
                    ExcCode_out = 5;
                end
                else if (reg_write && GRF_write == 0) begin
                    Exc_out = 1;
                    ExcCode_out = 12;
                end
                else begin
                    Exc_out = Exc_in;
                    ExcCode_out = ExcCode_in;
                end
            end else begin
                Exc_out = Exc_in;
                ExcCode_out = ExcCode_in;
            end
        end
    end

endmodule