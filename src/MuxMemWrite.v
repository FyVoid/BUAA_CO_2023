module MuxMemWrite(
    input [3:0] mem_write,
    input [31:0] mem_addr,
    output reg [3:0] out
);

    reg [1:0] byte;

    always @(*) begin
        byte = mem_addr[1:0];
        // sw
        if (mem_write == 4'b1111) begin
            out = 4'b1111;
        end
        // sb
        else if (mem_write == 4'b0001) begin
            if (byte == 0) out = 4'b0001;
            else if (byte == 1) out = 4'b0010;
            else if (byte == 2) out = 4'b0100;
            else if (byte == 3) out = 4'b1000;
        end
        // sh
        else if (mem_write == 4'b0011) begin
            if (byte == 0) out = 4'b0011;
            else if (byte == 2'b10) out = 4'b1100;
        end
        else begin
            out = 4'b0000;
        end
        
    end

endmodule