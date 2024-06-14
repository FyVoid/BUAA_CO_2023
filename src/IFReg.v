module IFReg(
    input clk,
    input reset,
    input enable,    

    input [4:0] RsAddr_IF_IN,
    input [4:0] RtAddr_IF_IN,
    input [4:0] RdAddr_IF_IN,
    input [15:0] addr16_IF_IN,
    input [25:0] addr26_IF_IN,
    input [31:0] PCAddr_IF_IN,
    input [3:0] ALUop_IF_IN,
    input [1:0] instruct_type_IF_IN,
    input [3:0] operand_type_IF_IN,
    input [3:0] GRF_write_IF_IN,
    input mem_write_IF_IN,
    input reg_write_IF_IN,
    input [2:0] jump_signal_IF_IN,

    output [4:0] RsAddr_IF_OUT,
    output [4:0] RtAddr_IF_OUT,
    output [4:0] RdAddr_IF_OUT,
    output [15:0] addr16_IF_OUT,
    output [25:0] addr26_IF_OUT,
    output [31:0] PCAddr_IF_OUT,
    output [3:0] ALUop_IF_OUT,
    output [1:0] instruct_type_IF_OUT,
    output [3:0] operand_type_IF_OUT,
    output [3:0] GRF_write_IF_OUT,
    output mem_write_IF_OUT,
    output reg_write_IF_OUT,
    output [2:0] jump_signal_IF_OUT,

    input [4:0] dst_addr_IF_IN,
    input [3:0] dst_save_IF_IN,
    input [3:0] rs_use_IF_IN,
    input [3:0] rt_use_IF_IN,
    
    output [4:0] dst_addr_IF_OUT,
    output reg [3:0] dst_save_IF_OUT,
    output reg [3:0] rs_use_IF_OUT,
    output reg [3:0] rt_use_IF_OUT
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
            dst_addr <= 0;
            dst_save <= 0;
            rs_use <= 4;
            rt_use <= 4;
        end else begin
            if (enable) begin
                RsAddr <= RsAddr_IF_IN;
                RtAddr <= RtAddr_IF_IN;
                RdAddr <= RdAddr_IF_IN;
                addr16 <= addr16_IF_IN;
                addr26 <= addr26_IF_IN;
                PCAddr <= PCAddr_IF_IN;
                ALUop <= ALUop_IF_IN;
                instruct_type <= instruct_type_IF_IN;
                operand_type <= operand_type_IF_IN;
                GRF_write <= GRF_write_IF_IN;
                mem_write <= mem_write_IF_IN;
                reg_write <= reg_write_IF_IN;
                jump_signal <= jump_signal_IF_IN;
                dst_addr <= dst_addr_IF_IN;
                dst_save <= dst_save_IF_IN;
                rs_use <= rs_use_IF_IN;
                rt_use <= rt_use_IF_IN;
            end
        end
    end

    assign RsAddr_IF_OUT = RsAddr;
    assign RtAddr_IF_OUT = RtAddr;
    assign RdAddr_IF_OUT = RdAddr;
    assign addr16_IF_OUT = addr16;
    assign addr26_IF_OUT = addr26;
    assign PCAddr_IF_OUT = PCAddr;
    assign ALUop_IF_OUT = ALUop;
    assign instruct_type_IF_OUT = instruct_type;
    assign operand_type_IF_OUT = operand_type;
    assign GRF_write_IF_OUT = GRF_write;
    assign mem_write_IF_OUT = mem_write;
    assign reg_write_IF_OUT = reg_write;
    assign jump_signal_IF_OUT = jump_signal;
    assign dst_addr_IF_OUT = dst_addr;

    always @(*) begin
        dst_save_IF_OUT = dst_save != 0 ? dst_save - 1 : 0;
        rs_use_IF_OUT = rs_use;
        rt_use_IF_OUT = rt_use;
    end

    // assign dst_save_IF_OUT = dst_save != 0 ? dst_save - 1 : 0;
    // assign rs_use_IF_OUT = rs_use != 0 ? rs_use - 1 : 0;
    // assign rt_use_IF_OUT = rt_use != 0 ? rt_use - 1 : 0;

endmodule