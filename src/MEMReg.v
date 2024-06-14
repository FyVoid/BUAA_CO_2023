module MEMReg(
    input clk,
    input reset,
    input enable,

    input [4:0] RsAddr_MEM_IN,
    input [4:0] RtAddr_MEM_IN,
    input [4:0] RdAddr_MEM_IN,
    input [15:0] addr16_MEM_IN,
    input [25:0] addr26_MEM_IN,
    input [31:0] PCAddr_MEM_IN,
    input [1:0] instruct_type_MEM_IN,
    input [3:0] operand_type_MEM_IN,
    input [3:0] GRF_write_MEM_IN,
    input reg_write_MEM_IN,
    input [2:0] jump_signal_MEM_IN,
    input [31:0] Rs_MEM_IN,
    input [31:0] Rt_MEM_IN,
    input [31:0] ALUOut_MEM_IN,
    input [31:0] DMOut_MEM_IN,

    output [4:0] RsAddr_MEM_OUT,
    output [4:0] RtAddr_MEM_OUT,
    output [4:0] RdAddr_MEM_OUT,
    output [15:0] addr16_MEM_OUT,
    output [25:0] addr26_MEM_OUT,
    output [31:0] PCAddr_MEM_OUT,
    output [1:0] instruct_type_MEM_OUT,
    output [3:0] operand_type_MEM_OUT,
    output [3:0] GRF_write_MEM_OUT,
    output reg_write_MEM_OUT,
    output [2:0] jump_signal_MEM_OUT,
    output [31:0] Rs_MEM_OUT,
    output [31:0] Rt_MEM_OUT,
    output [31:0] ALUOut_MEM_OUT,
    output [31:0] DMOut_MEM_OUT,

    input [4:0] dst_addr_MEM_IN,
    input [3:0] dst_save_MEM_IN,

    output [4:0] dst_addr_MEM_OUT,
    output reg [3:0] dst_save_MEM_OUT,

    input [31:0] hi_MEM_IN,
    output [31:0] hi_MEM_OUT,
    input [31:0] lo_MEM_IN,
    output [31:0] lo_MEM_OUT
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
    reg reg_write;
    reg [2:0] jump_signal;
    reg [31:0] Rs;
    reg [31:0] Rt;
    reg [31:0] ALUOut;
    reg [31:0] DMOut;
    reg [4:0] dst_addr;
    reg [3:0] dst_save;
    reg [31:0] hi;
    reg [31:0] lo;

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
            reg_write <= 0;
            jump_signal <= 0;
            Rs <= 0;
            Rt <= 0;
            ALUOut <= 0;
            DMOut <= 0;
            dst_addr <= 4;
            dst_save <= 4;
            hi <= 0;
            lo <= 0;
        end else begin
            if (enable) begin
                RsAddr <= RsAddr_MEM_IN;
                RtAddr <= RtAddr_MEM_IN;
                RdAddr <= RdAddr_MEM_IN;
                addr16 <= addr16_MEM_IN;
                addr26 <= addr26_MEM_IN;
                PCAddr <= PCAddr_MEM_IN;
                instruct_type <= instruct_type_MEM_IN;
                operand_type <= operand_type_MEM_IN;
                GRF_write <= GRF_write_MEM_IN;
                reg_write <= reg_write_MEM_IN;
                jump_signal <= jump_signal_MEM_IN;
                Rs <= Rs_MEM_IN;
                Rt <= Rt_MEM_IN;
                ALUOut <= ALUOut_MEM_IN;
                DMOut <= DMOut_MEM_IN;
                dst_addr <= dst_addr_MEM_IN;
                dst_save <= dst_save_MEM_IN;
                hi <= hi_MEM_IN;
                lo <= lo_MEM_IN;
            end
        end
    end

    assign RsAddr_MEM_OUT = RsAddr;
    assign RtAddr_MEM_OUT = RtAddr;
    assign RdAddr_MEM_OUT = RdAddr;
    assign addr16_MEM_OUT = addr16;
    assign addr26_MEM_OUT = addr26;
    assign PCAddr_MEM_OUT = PCAddr;
    assign instruct_type_MEM_OUT = instruct_type;
    assign operand_type_MEM_OUT = operand_type;
    assign GRF_write_MEM_OUT = GRF_write;
    assign reg_write_MEM_OUT = reg_write;
    assign jump_signal_MEM_OUT = jump_signal;
    assign Rs_MEM_OUT = Rs;
    assign Rt_MEM_OUT = Rt;
    assign ALUOut_MEM_OUT = ALUOut;
    assign DMOut_MEM_OUT = DMOut;
    assign dst_addr_MEM_OUT = dst_addr;
    assign hi_MEM_OUT = hi;
    assign lo_MEM_OUT = lo;

    always @(*) begin
        dst_save_MEM_OUT = dst_save != 0 ? dst_save - 1 : 0;
    end 
    
    // assign dst_save_MEM_OUT = dst_save != 0 ? dst_save - 1 : 0;

endmodule