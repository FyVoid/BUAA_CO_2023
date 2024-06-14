module mips(
    input clk,
    input reset
);
    wire [31:0] instruct;
    wire [31:0] JumpOffset;
    wire [31:0] Rs;
    wire [31:0] Rt;

    wire [31:0] MemOut;
    wire [31:0] PCAddr;
    wire [31:0] ALUOut;

    wire [5:0] op;
    wire [4:0] RsAddr;
    wire [4:0] RtAddr;
    wire [4:0] RdAddr;
    wire [4:0] Shamt;
    wire [5:0] func;
    wire [15:0] addr16;
    wire [25:0] addr26;

    wire [3:0] ALUop;
    wire [1:0] instruct_type;
    wire [3:0] operand_type;
    wire [3:0] GRF_write;
    wire mem_write;
    wire reg_write;
    wire [2:0] jump_signal;

    wire [0:2] compare;
    

    ID id(
        .instruct(instruct),
        .op(op),
        .RsAddr(RsAddr),
        .RtAddr(RtAddr),
        .RdAddr(RdAddr),
        .Shamt(Shamt),
        .func(func),
        .addr16(addr16),
        .addr26(addr26)
    );

    Mux2IFU mux2ifu(
        .addr16(addr16),
        .addr26(addr26),
        .Rs(Rs),
        .PC(PCAddr),
        .jump_signal(jump_signal),
        .compare(compare),
        .jump_flag(jump_flag),
        .JumpOffset(JumpOffset)
    );

    IFU ifu(
        .clk(clk),
        .reset(reset),
        .jump_flag(jump_flag),
        .JumpOffset(JumpOffset),
        .instruct(instruct),
        .PCAddr(PCAddr)
    );

    Controller controller(
        .op(op),
        .func(func),
        .ALUop(ALUop),
        .instruct_type(instruct_type),
        .operand_type(operand_type),
        .GRF_write(GRF_write),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .jump_signal(jump_signal)
    );

    wire [4:0] GRF_WriteAddr;
    wire [4:0] GRF_ReadAddr1;
    wire [4:0] GRF_ReadAddr2;
    wire [31:0] GRF_RegData;

    Mux2GRF mux2grf(
        .instruct_type(instruct_type),
        .GRF_write(GRF_write),
        .jump_signal(jump_signal),
        .RsAddr(RsAddr),
        .RtAddr(RtAddr),
        .RdAddr(RdAddr),
        .MemOut(MemOut),
        .ALUOut(ALUOut),
        .PCAddr(PCAddr),
        .imm(addr16),
        .WriteAddr(GRF_WriteAddr),
        .ReadAddr1(GRF_ReadAddr1),
        .ReadAddr2(GRF_ReadAddr2),
        .RegData(GRF_RegData)
    );

    GRF grf(
        .reg_write(reg_write),
        .clk(clk),
        .reset(reset),
        .RegData(GRF_RegData),
        .WriteAddr(GRF_WriteAddr),
        .PC(PCAddr),
        .ReadAddr1(GRF_ReadAddr1),
        .ReadAddr2(GRF_ReadAddr2),
        .GRFOut1(Rs),
        .GRFOut2(Rt)
    );

    wire [31:0] DM_WriteAddr;
    wire [31:0] DM_WriteData;

    Mux2DM mux2dm(
        .ALUOut(ALUOut),
        .Rt(Rt),
        .DM_WriteData(DM_WriteData),
        .Addr(DM_WriteAddr)
    );

    DM dm(
        .clk(clk),
        .reset(reset),
        .Addr(DM_WriteAddr),
        .WriteData(DM_WriteData),
        .PC(PCAddr),
        .mem_write(mem_write),
        .DMOut(MemOut)
    );

    wire [31:0] ALU_Operand1;
    wire [31:0] ALU_Operand2;

    Mux2ALU mux2alu(
        .operand_type(operand_type),
        .Rs(Rs),
        .Rt(Rt),
        .imm(addr16),
        .operand1(ALU_Operand1),
        .operand2(ALU_Operand2)
    );

    ALU alu(
        .ALUop(ALUop),
        .operand1(ALU_Operand1),
        .operand2(ALU_Operand2),
        .ALUOut(ALUOut),
        .compare(compare)
    );

    always @(posedge clk) begin
        if (!reset) begin
            if (reg_write) begin
                $display("@%h: $%d <= %h", PCAddr, GRF_WriteAddr, GRF_RegData);
            end
            if (mem_write) begin
                $display("@%h: *%h <= %h", PCAddr, DM_WriteAddr, Rt);
            end
        end
    end

    // display modules
    // GRF_display grf_display(
    //     .clk(clk),
    //     .reg_write(reg_write),
    //     .PC(PCAddr),
    //     .GRF_WriteAddr(GRF_WriteAddr),
    //     .GRF_RegData(GRF_RegData)
    // );

    // DM_display dm_display(
    //     .clk(clk),
    //     .mem_write(mem_write),
    //     .PC(PCAddr),
    //     .DM_WriteAddr(DM_WriteAddr),
    //     .DM_WriteData(Rt)
    // );

endmodule