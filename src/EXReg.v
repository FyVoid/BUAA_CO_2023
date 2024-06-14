module EXReg(
    input clk,
    input reset,
    input enable,

    input [4:0] RsAddr_EX_IN,
    input [4:0] RtAddr_EX_IN,
    input [4:0] RdAddr_EX_IN,
    input [15:0] addr16_EX_IN,
    input [25:0] addr26_EX_IN,
    input [31:0] PCAddr_EX_IN,
    input [1:0] instruct_type_EX_IN,
    input [3:0] operand_type_EX_IN,
    input [3:0] GRF_write_EX_IN,
    input [3:0] mem_write_EX_IN,
    input reg_write_EX_IN,
    input [2:0] jump_signal_EX_IN,
    input [31:0] Rs_EX_IN,
    input [31:0] Rt_EX_IN,
    input [31:0] ALUOut_EX_IN,

    output [4:0] RsAddr_EX_OUT,
    output [4:0] RtAddr_EX_OUT,
    output [4:0] RdAddr_EX_OUT,
    output [15:0] addr16_EX_OUT,
    output [25:0] addr26_EX_OUT,
    output [31:0] PCAddr_EX_OUT,
    output [1:0] instruct_type_EX_OUT,
    output [3:0] operand_type_EX_OUT,
    output [3:0] GRF_write_EX_OUT,
    output [3:0] mem_write_EX_OUT,
    output reg_write_EX_OUT,
    output [2:0] jump_signal_EX_OUT,
    output [31:0] Rs_EX_OUT,
    output [31:0] Rt_EX_OUT,
    output [31:0] ALUOut_EX_OUT,

    input [4:0] dst_addr_EX_IN,
    input [3:0] dst_save_EX_IN,
    input [3:0] rs_use_EX_IN,
    input [3:0] rt_use_EX_IN,

    output [4:0] dst_addr_EX_OUT,
    output reg [3:0] dst_save_EX_OUT,
    output reg [3:0] rs_use_EX_OUT,
    output reg [3:0] rt_use_EX_OUT,

    input [31:0] hi_EX_IN,
    output [31:0] hi_EX_OUT,
    input [31:0] lo_EX_IN,
    output [31:0] lo_EX_OUT,

    input [31:0] CP0Out_EX_IN,
    output [31:0] CP0Out_EX_OUT
);

    reg [4:0] RsAddr;
    reg [4:0] RtAddr;
    reg [4:0] RdAddr;
    reg [15:0] addr16;
    reg [25:0] addr26;
    reg [31:0] PCAddr;
    reg [1:0] instruct_type;
    reg [3:0] operand_type;
    reg [3:0] GRF_write;
    reg [3:0] mem_write;
    reg reg_write;
    reg [2:0] jump_signal;
    reg [31:0] Rs;
    reg [31:0] Rt;
    reg [31:0] ALUOut;
    reg [4:0] dst_addr;
    reg [3:0] dst_save;
    reg [3:0] rs_use;
    reg [3:0] rt_use;
    reg [31:0] hi;
    reg [31:0] lo;

    reg [31:0] CP0Out;

    always @(posedge clk) begin
        if (reset) begin
            RsAddr <= 0;
            RtAddr <= 0;
            RdAddr <= 0;
            addr16 <= 0;
            addr26 <= 0;
            PCAddr <= 0;
            instruct_type <= 0;
            operand_type <= 0;
            GRF_write <= 0;
            mem_write <= 0;
            reg_write <= 0;
            jump_signal <= 0;
            Rs <= 0;
            Rt <= 0;
            ALUOut <= 0;
            dst_addr <= 0;
            dst_save <= 0;
            rs_use <= 4;
            rt_use <= 4;
            hi <= 0;
            lo <= 0;
            CP0Out <= 0;
        end else begin
            if (enable) begin
                RsAddr <= RsAddr_EX_IN;
                RtAddr <= RtAddr_EX_IN;
                RdAddr <= RdAddr_EX_IN;
                addr16 <= addr16_EX_IN;
                addr26 <= addr26_EX_IN;
                PCAddr <= PCAddr_EX_IN;
                instruct_type <= instruct_type_EX_IN;
                operand_type <= operand_type_EX_IN;
                GRF_write <= GRF_write_EX_IN;
                mem_write <= mem_write_EX_IN;
                reg_write <= reg_write_EX_IN;
                jump_signal <= jump_signal_EX_IN;
                Rs <= Rs_EX_IN;
                Rt <= Rt_EX_IN;
                ALUOut <= ALUOut_EX_IN;
                dst_addr <= dst_addr_EX_IN;
                dst_save <= dst_save_EX_IN;
                rs_use <= rs_use_EX_IN;
                rt_use <= rt_use_EX_IN;
                hi <= hi_EX_IN;
                lo <= lo_EX_IN;
                CP0Out <= CP0Out_EX_IN;
            end
        end
    end

    assign RsAddr_EX_OUT = RsAddr;
    assign RtAddr_EX_OUT = RtAddr;
    assign RdAddr_EX_OUT = RdAddr;
    assign addr16_EX_OUT = addr16;
    assign addr26_EX_OUT = addr26;
    assign PCAddr_EX_OUT = PCAddr;
    assign instruct_type_EX_OUT = instruct_type;
    assign operand_type_EX_OUT = operand_type;
    assign GRF_write_EX_OUT = GRF_write;
    assign mem_write_EX_OUT = mem_write;
    assign reg_write_EX_OUT = reg_write;
    assign jump_signal_EX_OUT = jump_signal;
    assign Rs_EX_OUT = Rs;
    assign Rt_EX_OUT = Rt;
    assign ALUOut_EX_OUT = ALUOut;
    assign dst_addr_EX_OUT = dst_addr;
    assign hi_EX_OUT = hi;
    assign lo_EX_OUT = lo;

    assign CP0Out_EX_OUT = CP0Out;

    always @(*) begin
        dst_save_EX_OUT = dst_save != 0 ? dst_save - 1 : 0;
        rs_use_EX_OUT = rs_use;
        rt_use_EX_OUT = rt_use;
    end

    // assign dst_save_EX_OUT = dst_save != 0 ? dst_save - 1 : 0;
    // assign rs_use_EX_OUT = rs_use != 0 ? rs_use - 1 : 0;
    // assign rt_use_EX_OUT = rt_use != 0 ? rt_use - 1 : 0;

endmodule