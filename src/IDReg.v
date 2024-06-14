module IDReg(
    input clk,
    input reset,
    input enable,

    input [4:0] RsAddr_ID_IN,
    input [4:0] RtAddr_ID_IN,
    input [4:0] RdAddr_ID_IN,
    input [15:0] addr16_ID_IN,
    input [25:0] addr26_ID_IN,
    input [31:0] PCAddr_ID_IN,
    input [3:0] ALUop_ID_IN,
    input [1:0] instruct_type_ID_IN,
    input [3:0] operand_type_ID_IN,
    input [3:0] GRF_write_ID_IN,
    input mem_write_ID_IN,
    input reg_write_ID_IN,
    input [2:0] jump_signal_ID_IN,
    input [31:0] Rs_ID_IN,
    input [31:0] Rt_ID_IN,

    output [4:0] RsAddr_ID_OUT,
    output [4:0] RtAddr_ID_OUT,
    output [4:0] RdAddr_ID_OUT,
    output [15:0] addr16_ID_OUT,
    output [25:0] addr26_ID_OUT,
    output [31:0] PCAddr_ID_OUT,
    output [3:0] ALUop_ID_OUT,
    output [1:0] instruct_type_ID_OUT,
    output [3:0] operand_type_ID_OUT,
    output [3:0] GRF_write_ID_OUT,
    output mem_write_ID_OUT,
    output reg_write_ID_OUT,
    output [2:0] jump_signal_ID_OUT,
    output [31:0] Rs_ID_OUT,
    output [31:0] Rt_ID_OUT,

    input [4:0] dst_addr_ID_IN,
    input [3:0] dst_save_ID_IN,
    input [3:0] rs_use_ID_IN,
    input [3:0] rt_use_ID_IN,

    output [4:0] dst_addr_ID_OUT,
    output reg [3:0] dst_save_ID_OUT,
    output reg [3:0] rs_use_ID_OUT,
    output reg [3:0] rt_use_ID_OUT
);

    reg [4:0] RsAddr;
    reg [4:0] RtAddr;
    reg [4:0] RdAddr;
    reg [15:0] addr16;
    reg [25:0] addr26;
    reg [31:0] PCAddr;
    reg [3:0] ALUop;
    reg [1:0] instruct_type;
    reg [3:0] operand_type;
    reg [3:0] GRF_write;
    reg mem_write;
    reg reg_write;
    reg [2:0] jump_signal;
    reg [31:0] Rs;
    reg [31:0] Rt;

    reg [4:0] dst_addr;
    reg [3:0] dst_save;
    reg [3:0] rs_use;
    reg [3:0] rt_use;

    always @(posedge clk) begin
        if (reset) begin
            RsAddr <= 0;
            RtAddr <= 0;
            RdAddr <= 0;
            addr16 <= 0;
            addr26 <= 0;
            PCAddr <= 0;
            ALUop <= 0;
            instruct_type <= 0;
            operand_type <= 0;
            GRF_write <= 0;
            mem_write <= 0;
            reg_write <= 0;
            jump_signal <= 0;
            Rs <= 0;
            Rt <= 0;
            dst_addr <= 0;
            dst_save <= 0;
            rs_use <= 4;
            rt_use <= 4;
        end else begin
            if (enable) begin
                RsAddr <= RsAddr_ID_IN;
                RtAddr <= RtAddr_ID_IN;
                RdAddr <= RdAddr_ID_IN;
                addr16 <= addr16_ID_IN;
                addr26 <= addr26_ID_IN;
                PCAddr <= PCAddr_ID_IN;
                ALUop <= ALUop_ID_IN;
                instruct_type <= instruct_type_ID_IN;
                operand_type <= operand_type_ID_IN;
                GRF_write <= GRF_write_ID_IN;
                mem_write <= mem_write_ID_IN;
                reg_write <= reg_write_ID_IN;
                jump_signal <= jump_signal_ID_IN;
                Rs <= Rs_ID_IN;
                Rt <= Rt_ID_IN;
                dst_addr <= dst_addr_ID_IN;
                dst_save <= dst_save_ID_IN;
                rs_use <= rs_use_ID_IN;
                rt_use <= rt_use_ID_IN;
            end
        end
    end

    assign RsAddr_ID_OUT = RsAddr;
    assign RtAddr_ID_OUT = RtAddr;
    assign RdAddr_ID_OUT = RdAddr;
    assign addr16_ID_OUT = addr16;
    assign addr26_ID_OUT = addr26;
    assign PCAddr_ID_OUT = PCAddr;
    assign ALUop_ID_OUT = ALUop;
    assign instruct_type_ID_OUT = instruct_type;
    assign operand_type_ID_OUT = operand_type;
    assign GRF_write_ID_OUT = GRF_write;
    assign mem_write_ID_OUT = mem_write;
    assign reg_write_ID_OUT = reg_write;
    assign jump_signal_ID_OUT = jump_signal;
    assign Rs_ID_OUT = Rs;
    assign Rt_ID_OUT = Rt;
    assign dst_addr_ID_OUT = dst_addr;

    always @(*) begin
        dst_save_ID_OUT = dst_save != 0 ? dst_save - 1 : 0;
        rs_use_ID_OUT = rs_use;
        rt_use_ID_OUT = rt_use;
    end

    // assign dst_save_ID_OUT = dst_save != 0 ? dst_save - 1 : 0;
    // assign rs_use_ID_OUT = rs_use != 0 ? rs_use - 1 : 0;
    // assign rt_use_ID_OUT = rt_use != 0 ? rt_use - 1 : 0;

endmodule