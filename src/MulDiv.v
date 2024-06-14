module MulDiv(
    input clk,
    input reset,
    input [3:0] ALUop,
    input [31:0] operand1,
    input [31:0] operand2,
    output [31:0] hi,
    output [31:0] lo,
    output busy
);

    reg [4:0] counter;
    reg [31:0] hi_reg;
    reg [31:0] lo_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            hi_reg <= 0;
            lo_reg <= 0;
        end else begin
            // mult
            if (ALUop == 2'b11) begin
                {hi_reg, lo_reg} <= $signed(operand1) * $signed(operand2);
                counter <= 5;
            end
            // multu
            else if (ALUop == 4'b1000) begin
                {hi_reg, lo_reg} <= operand1 * operand2;
                counter <= 5;
            end
            // div
            else if (ALUop == 3'b100) begin
                hi_reg <= $signed(operand1) % $signed(operand2);
                lo_reg <= $signed(operand1) / $signed(operand2);
                counter <= 10;
            end 
            // divu
            else if (ALUop == 4'b1001) begin
                hi_reg <= operand1 % operand2;
                lo_reg <= operand1 / operand2;
                counter <= 10;
            end
            else begin
                // mthi
                if (ALUop == 4'b1010) begin
                    hi_reg <= operand1;
                end
                // mtlo
                else if (ALUop == 4'b1011) begin
                    lo_reg <= operand1;
                end
                
                if (counter != 0) begin
                    counter <= counter - 1;
                end
            end
        end
    end

    assign busy = counter != 0;

    assign hi = busy ? 0 : hi_reg;

    assign lo = busy ? 0 : lo_reg;

endmodule