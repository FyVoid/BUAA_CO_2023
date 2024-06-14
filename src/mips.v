module mips(
    input clk,
    input reset,

    output [31:0] i_inst_addr,
    input [31:0] i_inst_rdata,

    input [31:0] m_data_rdata,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,

    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);

    // pipeline controller
    wire enable_pc;

    wire [31:0] Rs_id_in;
    wire [31:0] Rt_id_in;
    wire enable_if;
    wire reset_if;

    wire [31:0] Rs_ex_in;
    wire [31:0] Rt_ex_in;
    wire enable_id;
    wire reset_id;

    wire [31:0] Rs_mem_in;
    wire [31:0] Rt_mem_in;
    wire enable_ex;
    wire reset_ex;

    wire enable_mem;
    wire reset_mem;
    ALRegController al_reg_controller(
        .reset(reset),
        .enable_PC(enable_pc),
        .busy(busy),

        .dst_addr_IF_OUT(dst_addr_if_out),
        .dst_save_IF_OUT(dst_save_if_out),
        .rs_use_IF_OUT(rs_use_if_out),
        .rt_use_IF_OUT(rt_use_if_out),
        .RsAddr_IF_OUT(RsAddr_if_out),
        .RtAddr_IF_OUT(RtAddr_if_out),
        .ALUop_IF_OUT(ALUop_if_out),
        .GRF_write_IF_OUT(GRF_write_if_out),
        .Rs_IF_OUT(Rs_grf_out),
        .Rt_IF_OUT(Rt_grf_out),
        .Rs_ID_IN(Rs_id_in),
        .Rt_ID_IN(Rt_id_in),
        .enable_IF(enable_if),
        .reset_IF(reset_if),

        .dst_addr_ID_OUT(dst_addr_id_out),
        .dst_save_ID_OUT(dst_save_id_out),
        .rs_use_ID_OUT(rs_use_id_out),
        .rt_use_ID_OUT(rt_use_id_out),
        .RsAddr_ID_OUT(RsAddr_id_out),
        .RtAddr_ID_OUT(RtAddr_id_out),
        .Rs_ID_OUT(Rs_id_out),
        .Rt_ID_OUT(Rt_id_out),
        .ALUop_ID_OUT(ALUop_id_out),
        .GRF_write_ID_OUT(GRF_write_id_out),
        .PCAddr_ID_OUT(PCAddr_id_out),
        .addr16_ID_OUT(addr16_id_out),
        .Rs_EX_IN(Rs_ex_in),
        .Rt_EX_IN(Rt_ex_in),
        .enable_ID(enable_id),
        .reset_ID(reset_id),

        .dst_addr_EX_OUT(dst_addr_ex_out),
        .dst_save_EX_OUT(dst_save_ex_out),
        .Rs_EX_OUT(Rs_ex_out),
        .Rt_EX_OUT(Rt_ex_out),
        .RsAddr_EX_OUT(RsAddr_ex_out),
        .RtAddr_EX_OUT(RtAddr_ex_out),
        .rs_use_EX_OUT(rs_use_ex_out),
        .rt_use_EX_OUT(rt_use_ex_out),
        .ALUOut_EX_OUT(ALUOut_ex_out),
        .hi_EX_OUT(hi_ex_out),
        .lo_EX_OUT(lo_ex_out),
        .PCAddr_EX_OUT(PCAddr_ex_out),
        .addr16_EX_OUT(addr16_ex_out),
        .GRF_write_EX_OUT(GRF_write_ex_out),
        .Rs_MEM_IN(Rs_mem_in),
        .Rt_MEM_IN(Rt_mem_in),
        .enable_EX(enable_ex),
        .reset_EX(reset_ex),

        .dst_addr_MEM_OUT(dst_addr_mem_out),
        .dst_save_MEM_OUT(dst_save_mem_out),
        .GRF_write_MEM_OUT(GRF_write_mem_out),
        .ALUOut_MEM_OUT(ALUOut_mem_out),
        .hi_MEM_OUT(hi_mem_out),
        .lo_MEM_OUT(lo_mem_out),
        .PCAddr_MEM_OUT(PCAddr_mem_out),
        .addr16_MEM_OUT(addr16_mem_out),
        .DMOut_MEM_OUT(DMOut_mem_out),
        .enable_MEM(enable_mem),
        .reset_MEM(reset_mem)

    );

    // pipeline part IF

    wire [31:0] instruct_ifu_out;
    assign instruct_ifu_out = i_inst_rdata;
    wire [31:0] PCAddr_ifu_out;
    assign i_inst_addr = PCAddr_ifu_out;
    IFU ifu(
        .clk(clk),
        .reset(reset),
        .enable(enable_pc),
        .jump_flag(jump_flag),
        .JumpOffset(JumpOffset),
        .PCAddr(PCAddr_ifu_out)
    );

    wire [5:0] op_idv_out;
    wire [4:0] RsAddr_idv_out;
    wire [4:0] RtAddr_idv_out;
    wire [4:0] RdAddr_idv_out;
    wire [4:0] Shamt_idv_out;
    wire [5:0] func_idv_out;
    wire [15:0] addr16_idv_out;
    wire [25:0] addr26_idv_out;
    IDiv idiv(
        .instruct(instruct_ifu_out),
        .op(op_idv_out),
        .RsAddr(RsAddr_idv_out),
        .RtAddr(RtAddr_idv_out),
        .RdAddr(RdAddr_idv_out),
        .Shamt(Shamt_idv_out),
        .func(func_idv_out),
        .addr16(addr16_idv_out),
        .addr26(addr26_idv_out)
    );

    wire [3:0] ALUop_ctrl_out;
    wire [1:0] instruct_type_ctrl_out;
    wire [3:0] operand_type_ctrl_out;
    wire [3:0] GRF_write_ctrl_out;
    wire [3:0] mem_write_ctrl_out;
    wire reg_write_ctrl_out;
    wire [2:0] jump_signal_ctrl_out;

    wire [4:0] dst_addr;
    wire [3:0] dst_save;
    wire [3:0] rs_use;
    wire [3:0] rt_use;
    Controller controller(
        .op(op_idv_out),
        .func(func_idv_out),
        .RdAddr(RdAddr_idv_out),
        .RtAddr(RtAddr_idv_out),
        .ALUop(ALUop_ctrl_out),
        .instruct_type(instruct_type_ctrl_out),
        .operand_type(operand_type_ctrl_out),
        .GRF_write(GRF_write_ctrl_out),
        .mem_write(mem_write_ctrl_out),
        .reg_write(reg_write_ctrl_out),
        .jump_signal(jump_signal_ctrl_out),
        .dst_addr(dst_addr),
        .dst_save(dst_save),
        .rs_use(rs_use),
        .rt_use(rt_use)
    );

    wire [4:0] RsAddr_if_out;
    wire [4:0] RtAddr_if_out;
    wire [4:0] RdAddr_if_out;
    wire [15:0] addr16_if_out;
    wire [25:0] addr26_if_out;
    wire [31:0] PCAddr_if_out;
    wire [3:0] ALUop_if_out;
    wire [1:0] instruct_type_if_out;
    wire [3:0] operand_type_if_out;
    wire [3:0] GRF_write_if_out;
    wire [3:0] mem_write_if_out;
    wire reg_write_if_out;
    wire [2:0] jump_signal_if_out;
    wire [4:0] dst_addr_if_out;
    wire [3:0] dst_save_if_out;
    wire [3:0] rs_use_if_out;
    wire [3:0] rt_use_if_out;
    IFReg ifreg(
        .clk(clk),
        .reset(reset_if),
        .enable(enable_if),

        .RsAddr_IF_IN(RsAddr_idv_out),
        .RtAddr_IF_IN(RtAddr_idv_out),
        .RdAddr_IF_IN(RdAddr_idv_out),
        .addr16_IF_IN(addr16_idv_out),
        .addr26_IF_IN(addr26_idv_out),
        .PCAddr_IF_IN(PCAddr_ifu_out),
        .ALUop_IF_IN(ALUop_ctrl_out),
        .instruct_type_IF_IN(instruct_type_ctrl_out),
        .operand_type_IF_IN(operand_type_ctrl_out),
        .GRF_write_IF_IN(GRF_write_ctrl_out),
        .mem_write_IF_IN(mem_write_ctrl_out),
        .reg_write_IF_IN(reg_write_ctrl_out),
        .jump_signal_IF_IN(jump_signal_ctrl_out),

        .RsAddr_IF_OUT(RsAddr_if_out),
        .RtAddr_IF_OUT(RtAddr_if_out),
        .RdAddr_IF_OUT(RdAddr_if_out),
        .addr16_IF_OUT(addr16_if_out),
        .addr26_IF_OUT(addr26_if_out),
        .PCAddr_IF_OUT(PCAddr_if_out),
        .ALUop_IF_OUT(ALUop_if_out),
        .instruct_type_IF_OUT(instruct_type_if_out),
        .operand_type_IF_OUT(operand_type_if_out),
        .GRF_write_IF_OUT(GRF_write_if_out),
        .mem_write_IF_OUT(mem_write_if_out),
        .reg_write_IF_OUT(reg_write_if_out),
        .jump_signal_IF_OUT(jump_signal_if_out),

        .dst_addr_IF_IN(dst_addr),
        .dst_save_IF_IN(dst_save),
        .rs_use_IF_IN(rs_use),
        .rt_use_IF_IN(rt_use),

        .dst_addr_IF_OUT(dst_addr_if_out),
        .dst_save_IF_OUT(dst_save_if_out),
        .rs_use_IF_OUT(rs_use_if_out),
        .rt_use_IF_OUT(rt_use_if_out)
    );

    // pipeline part IF

    // pipeline part ID

    wire [4:0] GRF_ReadAddr1;
    wire [4:0] GRF_ReadAddr2;
    Mux2GRF_ID mux2grf_id(
        .RsAddr(RsAddr_if_out),
        .RtAddr(RtAddr_if_out),
        .ReadAddr1(GRF_ReadAddr1),
        .ReadAddr2(GRF_ReadAddr2)
    );

    wire [31:0] Rs_grf_out;
    wire [31:0] Rt_grf_out;
    GRF grf(
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write_mem_out),
        .RegData(GRF_RegData),
        .WriteAddr(GRF_WriteAddr),
        .PC(PCAddr_mem_out),
        .ReadAddr1(GRF_ReadAddr1),
        .ReadAddr2(GRF_ReadAddr2),
        .GRFOut1(Rs_grf_out),
        .GRFOut2(Rt_grf_out)
    );

    wire [31:0] compare_comparer_out;
    Comparer comparer(
        .operand1(Rs_id_in),
        .operand2(Rt_id_in),
        .compare(compare_comparer_out)
    );

    wire jump_flag;
    wire [31:0] JumpOffset;
    Mux2IFU mux2ifu(
        .addr16(addr16_if_out),
        .addr26(addr26_if_out),
        .Rs(Rs_id_in),
        .PC(PCAddr_if_out),
        .jump_signal(jump_signal_if_out),
        .compare(compare_comparer_out),
        .jump_flag(jump_flag),
        .JumpOffset(JumpOffset)
    );


    wire [4:0] RsAddr_id_out;
    wire [4:0] RtAddr_id_out;
    wire [4:0] RdAddr_id_out;
    wire [15:0] addr16_id_out;
    wire [25:0] addr26_id_out;
    wire [31:0] PCAddr_id_out;
    wire [3:0] ALUop_id_out;
    wire [1:0] instruct_type_id_out;
    wire [3:0] operand_type_id_out;
    wire [3:0] GRF_write_id_out;
    wire [3:0] mem_write_id_out;
    wire reg_write_id_out;
    wire [2:0] jump_signal_id_out;
    wire [31:0] Rs_id_out;
    wire [31:0] Rt_id_out;
    wire [4:0] dst_addr_id_out;
    wire [3:0] dst_save_id_out;
    wire [3:0] rs_use_id_out;
    wire [3:0] rt_use_id_out;
    IDReg idreg(
        .clk(clk),
        .reset(reset_id),
        .enable(enable_id),

        .RsAddr_ID_IN(RsAddr_if_out),
        .RtAddr_ID_IN(RtAddr_if_out),
        .RdAddr_ID_IN(RdAddr_if_out),
        .addr16_ID_IN(addr16_if_out),
        .addr26_ID_IN(addr26_if_out),
        .PCAddr_ID_IN(PCAddr_if_out),
        .ALUop_ID_IN(ALUop_if_out),
        .instruct_type_ID_IN(instruct_type_if_out),
        .operand_type_ID_IN(operand_type_if_out),
        .GRF_write_ID_IN(GRF_write_if_out),
        .mem_write_ID_IN(mem_write_if_out),
        .reg_write_ID_IN(reg_write_if_out),
        .jump_signal_ID_IN(jump_signal_if_out),
        .Rs_ID_IN(Rs_id_in),
        .Rt_ID_IN(Rt_id_in),

        .RsAddr_ID_OUT(RsAddr_id_out),
        .RtAddr_ID_OUT(RtAddr_id_out),
        .RdAddr_ID_OUT(RdAddr_id_out),
        .addr16_ID_OUT(addr16_id_out),
        .addr26_ID_OUT(addr26_id_out),
        .PCAddr_ID_OUT(PCAddr_id_out),
        .ALUop_ID_OUT(ALUop_id_out),
        .instruct_type_ID_OUT(instruct_type_id_out),
        .operand_type_ID_OUT(operand_type_id_out),
        .GRF_write_ID_OUT(GRF_write_id_out),
        .mem_write_ID_OUT(mem_write_id_out),
        .reg_write_ID_OUT(reg_write_id_out),
        .jump_signal_ID_OUT(jump_signal_id_out),
        .Rs_ID_OUT(Rs_id_out),
        .Rt_ID_OUT(Rt_id_out),

        .dst_addr_ID_IN(dst_addr_if_out),
        .dst_save_ID_IN(dst_save_if_out),
        .rs_use_ID_IN(rs_use_if_out),
        .rt_use_ID_IN(rt_use_if_out),

        .dst_addr_ID_OUT(dst_addr_id_out),
        .dst_save_ID_OUT(dst_save_id_out),
        .rs_use_ID_OUT(rs_use_id_out),
        .rt_use_ID_OUT(rt_use_id_out)
    );

    // pipeline part ID

    // pipeline part EX

    wire [31:0] ALU_Operand1;
    wire [31:0] ALU_Operand2;
    Mux2ALU mux2alu(
        .operand_type(operand_type_id_out),
        .Rs(Rs_ex_in),
        .Rt(Rt_ex_in),
        .imm(addr16_id_out),
        .operand1(ALU_Operand1),
        .operand2(ALU_Operand2)
    );

    wire [31:0] val_alu_out;
    wire [31:0] compare_alu_out;
    ALU alu(
        .ALUop(ALUop_id_out),
        .operand1(ALU_Operand1),
        .operand2(ALU_Operand2),
        .ALUOut(val_alu_out),
        .compare(compare_alu_out)
    );

    wire [31:0] val_hi;
    wire [31:0] val_lo;
    wire busy;
    MulDiv muldiv(
        .clk(clk),
        .reset(reset),
        .ALUop(ALUop_id_out),
        .operand1(ALU_Operand1),
        .operand2(ALU_Operand2),
        .hi(val_hi),
        .lo(val_lo),
        .busy(busy)
    );

    wire [4:0] RsAddr_ex_out;
    wire [4:0] RtAddr_ex_out;
    wire [4:0] RdAddr_ex_out;
    wire [15:0] addr16_ex_out;
    wire [25:0] addr26_ex_out;
    wire [31:0] PCAddr_ex_out;
    wire [1:0] instruct_type_ex_out;
    wire [3:0] operand_type_ex_out;
    wire [3:0] GRF_write_ex_out;
    wire [3:0] mem_write_ex_out;
    wire reg_write_ex_out;
    wire [2:0] jump_signal_ex_out;
    wire [31:0] Rs_ex_out;
    wire [31:0] Rt_ex_out;
    wire [31:0] ALUOut_ex_out;
    wire [4:0] dst_addr_ex_out;
    wire [3:0] dst_save_ex_out;
    wire [3:0] rs_use_ex_out;
    wire [3:0] rt_use_ex_out;
    wire [31:0] hi_ex_out;
    wire [31:0] lo_ex_out;
    EXReg exreg(
        .clk(clk),
        .reset(reset_ex),
        .enable(enable_ex),

        .RsAddr_EX_IN(RsAddr_id_out),
        .RtAddr_EX_IN(RtAddr_id_out),
        .RdAddr_EX_IN(RdAddr_id_out),
        .addr16_EX_IN(addr16_id_out),
        .addr26_EX_IN(addr26_id_out),
        .PCAddr_EX_IN(PCAddr_id_out),
        .instruct_type_EX_IN(instruct_type_id_out),
        .operand_type_EX_IN(operand_type_id_out),
        .GRF_write_EX_IN(GRF_write_id_out),
        .mem_write_EX_IN(mem_write_id_out),
        .reg_write_EX_IN(reg_write_id_out),
        .jump_signal_EX_IN(jump_signal_id_out),
        .Rs_EX_IN(Rs_ex_in),
        .Rt_EX_IN(Rt_ex_in),
        .ALUOut_EX_IN(val_alu_out),

        .RsAddr_EX_OUT(RsAddr_ex_out),
        .RtAddr_EX_OUT(RtAddr_ex_out),
        .RdAddr_EX_OUT(RdAddr_ex_out),
        .addr16_EX_OUT(addr16_ex_out),
        .addr26_EX_OUT(addr26_ex_out),
        .PCAddr_EX_OUT(PCAddr_ex_out),
        .instruct_type_EX_OUT(instruct_type_ex_out),
        .operand_type_EX_OUT(operand_type_ex_out),
        .GRF_write_EX_OUT(GRF_write_ex_out),
        .mem_write_EX_OUT(mem_write_ex_out),
        .reg_write_EX_OUT(reg_write_ex_out),
        .jump_signal_EX_OUT(jump_signal_ex_out),
        .Rs_EX_OUT(Rs_ex_out),
        .Rt_EX_OUT(Rt_ex_out),
        .ALUOut_EX_OUT(ALUOut_ex_out),

        .dst_addr_EX_IN(dst_addr_id_out),
        .dst_save_EX_IN(dst_save_id_out),
        .rs_use_EX_IN(rs_use_id_out),
        .rt_use_EX_IN(rt_use_id_out),

        .dst_addr_EX_OUT(dst_addr_ex_out),
        .dst_save_EX_OUT(dst_save_ex_out),
        .rs_use_EX_OUT(rs_use_ex_out),
        .rt_use_EX_OUT(rt_use_ex_out),

        .hi_EX_IN(val_hi),
        .hi_EX_OUT(hi_ex_out),
        .lo_EX_IN(val_lo),
        .lo_EX_OUT(lo_ex_out)
    );

    // pipeline part EX

    // pipeline part MEM

    wire [31:0] DM_WriteAddr;
    wire [31:0] DM_WriteData;
    Mux2DM mux2dm(
        .ALUOut(ALUOut_ex_out),
        .Rt(Rt_mem_in),
        .DM_WriteData(DM_WriteData),
        .Addr(DM_WriteAddr)
    );

    wire [31:0] val_dm_out;
    assign val_dm_out = m_data_rdata;
    assign m_data_addr = DM_WriteAddr;
    assign m_data_wdata = DM_WriteData << (8 * DM_WriteAddr[1:0]);

    MuxMemWrite muxmemwrite(
        .mem_write(mem_write_ex_out),
        .mem_addr(DM_WriteAddr),
        .out(m_data_byteen)
    );

    // assign m_data_byteen = mem_write_ex_out;
    assign m_inst_addr = PCAddr_ex_out;

    wire [4:0] RsAddr_mem_out;
    wire [4:0] RtAddr_mem_out;
    wire [4:0] RdAddr_mem_out;
    wire [15:0] addr16_mem_out;
    wire [25:0] addr26_mem_out;
    wire [31:0] PCAddr_mem_out;
    wire [1:0] instruct_type_mem_out;
    wire [3:0] operand_type_mem_out;
    wire [3:0] GRF_write_mem_out;
    wire reg_write_mem_out;
    wire [2:0] jump_signal_mem_out;
    wire [31:0] Rs_mem_out;
    wire [31:0] Rt_mem_out;
    wire [31:0] ALUOut_mem_out;
    wire [0:2] compare_mem_out;
    wire [31:0] DMOut_mem_out;
    wire [4:0] dst_addr_mem_out;
    wire [3:0] dst_save_mem_out;
    wire [31:0] hi_mem_out;
    wire [31:0] lo_mem_out;
    MEMReg memreg(
        .clk(clk),
        .reset(reset_mem),
        .enable(enable_mem),

        .RsAddr_MEM_IN(RsAddr_ex_out),
        .RtAddr_MEM_IN(RtAddr_ex_out),
        .RdAddr_MEM_IN(RdAddr_ex_out),
        .addr16_MEM_IN(addr16_ex_out),
        .addr26_MEM_IN(addr26_ex_out),
        .PCAddr_MEM_IN(PCAddr_ex_out),
        .instruct_type_MEM_IN(instruct_type_ex_out),
        .operand_type_MEM_IN(operand_type_ex_out),
        .GRF_write_MEM_IN(GRF_write_ex_out),
        .reg_write_MEM_IN(reg_write_ex_out),
        .jump_signal_MEM_IN(jump_signal_ex_out),
        .Rs_MEM_IN(Rs_mem_in),
        .Rt_MEM_IN(Rt_mem_in),
        .ALUOut_MEM_IN(ALUOut_ex_out),
        .DMOut_MEM_IN(val_dm_out),

        .RsAddr_MEM_OUT(RsAddr_mem_out),
        .RtAddr_MEM_OUT(RtAddr_mem_out),
        .RdAddr_MEM_OUT(RdAddr_mem_out),
        .addr16_MEM_OUT(addr16_mem_out),
        .addr26_MEM_OUT(addr26_mem_out),
        .PCAddr_MEM_OUT(PCAddr_mem_out),
        .instruct_type_MEM_OUT(instruct_type_mem_out),
        .operand_type_MEM_OUT(operand_type_mem_out),
        .GRF_write_MEM_OUT(GRF_write_mem_out),
        .reg_write_MEM_OUT(reg_write_mem_out),
        .jump_signal_MEM_OUT(jump_signal_mem_out),
        .Rs_MEM_OUT(Rs_mem_out),
        .Rt_MEM_OUT(Rt_mem_out),
        .ALUOut_MEM_OUT(ALUOut_mem_out),
        .DMOut_MEM_OUT(DMOut_mem_out),
        
        .dst_addr_MEM_IN(dst_addr_ex_out),
        .dst_save_MEM_IN(dst_save_ex_out),
        .dst_addr_MEM_OUT(dst_addr_mem_out),
        .dst_save_MEM_OUT(dst_save_mem_out),
        
        .hi_MEM_IN(hi_ex_out),
        .hi_MEM_OUT(hi_mem_out),
        .lo_MEM_IN(lo_ex_out),
        .lo_MEM_OUT(lo_mem_out)
    );

    // pipeline part MEM

    // pipeline part WB

    wire [4:0] GRF_WriteAddr;
    wire [31:0] GRF_RegData;
    Mux2GRF_WB mux2grf_wb(
        .instruct_type(instruct_type_mem_out),
        .GRF_write(GRF_write_mem_out),
        .RsAddr(RsAddr_mem_out),
        .RtAddr(RtAddr_mem_out),
        .RdAddr(RdAddr_mem_out),
        .MemOut(DMOut_mem_out),
        .ALUOut(ALUOut_mem_out),
        .PCAddr(PCAddr_mem_out),
        .imm(addr16_mem_out),
        .hi(hi_mem_out),
        .lo(lo_mem_out),
        .WriteAddr(GRF_WriteAddr),
        .RegData(GRF_RegData)
    );

    assign w_grf_we = reg_write_mem_out;
    assign w_grf_addr = GRF_WriteAddr;
    assign w_grf_wdata = GRF_RegData;
    assign w_inst_addr = PCAddr_mem_out;

    // pipeline part WB

endmodule