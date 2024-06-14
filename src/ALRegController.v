module ALRegController(
    input reset,
    output reg enable_PC,

    // IF-ID
    input [4:0] dst_addr_IF_OUT,
    input [3:0] dst_save_IF_OUT,
    input [3:0] rs_use_IF_OUT,
    input [3:0] rt_use_IF_OUT,
    input [4:0] RsAddr_IF_OUT,
    input [4:0] RtAddr_IF_OUT,
    input [31:0] Rs_IF_OUT,
    input [31:0] Rt_IF_OUT,
    output reg [31:0] Rs_ID_IN,
    output reg [31:0] Rt_ID_IN,
    output reg enable_IF,
    output reg reset_IF,

    // ID-EX
    input [4:0] dst_addr_ID_OUT,
    input [3:0] dst_save_ID_OUT,
    input [3:0] rs_use_ID_OUT,
    input [3:0] rt_use_ID_OUT,
    input [4:0] RsAddr_ID_OUT,
    input [4:0] RtAddr_ID_OUT,
    input [31:0] Rs_ID_OUT,
    input [31:0] Rt_ID_OUT,
    input [3:0] GRF_write_ID_OUT,
    input [31:0] PCAddr_ID_OUT,
    input [15:0] addr16_ID_OUT,
    output reg [31:0] Rs_EX_IN,
    output reg [31:0] Rt_EX_IN,
    output reg enable_ID,
    output reg reset_ID,

    // EX-MEM
    input [4:0] dst_addr_EX_OUT,
    input [3:0] dst_save_EX_OUT,
    input [3:0] rs_use_EX_OUT,
    input [3:0] rt_use_EX_OUT,
    input [4:0] RsAddr_EX_OUT,
    input [4:0] RtAddr_EX_OUT,
    input [31:0] Rs_EX_OUT,
    input [31:0] Rt_EX_OUT,
    input [31:0] ALUOut_EX_OUT,
    input [31:0] PCAddr_EX_OUT,
    input [15:0] addr16_EX_OUT,
    input [3:0] GRF_write_EX_OUT,
    output reg [31:0] Rs_MEM_IN,
    output reg [31:0] Rt_MEM_IN,
    output reg enable_EX,
    output reg reset_EX,

    // MEM-WB
    input [4:0] dst_addr_MEM_OUT,
    input [3:0] dst_save_MEM_OUT,
    input [3:0] GRF_write_MEM_OUT,
    input [31:0] ALUOut_MEM_OUT,
    input [31:0] PCAddr_MEM_OUT,
    input [15:0] addr16_MEM_OUT,
    input [31:0] DMOut_MEM_OUT,
    output reg enable_MEM,
    output reg reset_MEM

);

    reg bubble_if;

    wire [31:0] id_forwarding;
    Mux_GRF_W mux_grf_w_id_forwarding(
        .GRF_write(GRF_write_ID_OUT),
        .PCAddr(PCAddr_ID_OUT),
        .imm(addr16_ID_OUT),
        .out(id_forwarding)
    );

    wire [31:0] ex_forwarding;
    Mux_GRF_W mux_grf_w_ex_forwarding(
        .GRF_write(GRF_write_EX_OUT),
        .ALUOut(ALUOut_EX_OUT),
        .PCAddr(PCAddr_EX_OUT),
        .imm(addr16_EX_OUT),
        .out(ex_forwarding)
    );

    wire [31:0] mem_forwarding;
    Mux_GRF_W mux_grf_w_mem_forwarding(
        .GRF_write(GRF_write_MEM_OUT),
        .ALUOut(ALUOut_MEM_OUT),
        .MemOut(DMOut_MEM_OUT),
        .PCAddr(PCAddr_MEM_OUT),
        .imm(addr16_MEM_OUT),
        .out(mem_forwarding)
    );

    always @(*) begin
        // EX-MEM
        if (rs_use_EX_OUT != 2 && rt_use_EX_OUT != 2) begin
            Rs_MEM_IN = Rs_EX_OUT;
            Rt_MEM_IN = Rt_EX_OUT;
        end else begin
            if (rs_use_EX_OUT == 2) begin
                if (RsAddr_EX_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0) begin
                    Rs_MEM_IN = mem_forwarding;
                end else begin
                    Rs_MEM_IN = Rs_EX_OUT;
                end
            end else begin
                Rs_MEM_IN = Rs_EX_OUT;
            end

            if (rt_use_EX_OUT == 2) begin
                if (RtAddr_EX_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0) begin
                    Rt_MEM_IN = mem_forwarding;
                end else begin
                    Rt_MEM_IN = Rt_EX_OUT;
                end
            end else begin
                Rt_MEM_IN = Rt_EX_OUT;
            end
        end
        
        // ID-EX
        if (rs_use_ID_OUT != 1 && rt_use_ID_OUT != 1) begin
            Rs_EX_IN = Rs_ID_OUT;
            Rt_EX_IN = Rt_ID_OUT;
        end else begin
            if (rs_use_ID_OUT == 1) begin
                if (RsAddr_ID_OUT == dst_addr_EX_OUT && dst_addr_EX_OUT != 0) begin
                    Rs_EX_IN = ex_forwarding;
                end else if (RsAddr_ID_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0) begin
                    Rs_EX_IN = mem_forwarding;
                end else begin
                    Rs_EX_IN = Rs_ID_OUT;
                end
            end else begin
                Rs_EX_IN = Rs_ID_OUT;
            end

            if (rt_use_ID_OUT == 1) begin
                if (RtAddr_ID_OUT == dst_addr_EX_OUT && dst_addr_EX_OUT != 0) begin
                    Rt_EX_IN = ex_forwarding;
                end else if (RtAddr_ID_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0) begin
                    Rt_EX_IN = mem_forwarding;
                end else begin
                    Rt_EX_IN = Rt_ID_OUT;
                end
            end else begin
                Rt_EX_IN = Rt_ID_OUT;
            end
        end

        // IF-ID
        if (rs_use_IF_OUT != 0 && rt_use_IF_OUT != 0) begin
            Rs_ID_IN = Rs_IF_OUT;
            Rt_ID_IN = Rt_IF_OUT;
        end else begin
            if (rs_use_IF_OUT == 0) begin
                if (RsAddr_IF_OUT == dst_addr_ID_OUT && dst_addr_ID_OUT != 0) begin
                    Rs_ID_IN = id_forwarding;
                end else if (RsAddr_IF_OUT == dst_addr_EX_OUT && dst_addr_EX_OUT != 0) begin
                    Rs_ID_IN = ex_forwarding;
                end else if (RsAddr_IF_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0) begin
                    Rs_ID_IN = mem_forwarding;
                end else begin
                    Rs_ID_IN = Rs_IF_OUT;
                end
            end else begin
                Rs_ID_IN = Rs_IF_OUT;
            end

            if (rt_use_IF_OUT == 0) begin
                if (RtAddr_IF_OUT == dst_addr_ID_OUT && dst_addr_ID_OUT != 0) begin
                    Rt_ID_IN = id_forwarding;
                end else if (RtAddr_IF_OUT == dst_addr_EX_OUT && dst_addr_EX_OUT != 0) begin
                    Rt_ID_IN = ex_forwarding;
                end else if (RtAddr_IF_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0) begin
                    Rt_ID_IN = mem_forwarding;
                end else begin
                    Rt_ID_IN = Rt_IF_OUT;
                end
            end else begin
                Rt_ID_IN = Rt_IF_OUT;
            end
        end

        // bubble check
        if (
            (rs_use_IF_OUT < dst_save_ID_OUT && RsAddr_IF_OUT == dst_addr_ID_OUT && dst_addr_ID_OUT != 0)
            || (rt_use_IF_OUT < dst_save_ID_OUT && RtAddr_IF_OUT == dst_addr_ID_OUT && dst_addr_ID_OUT != 0)
            || (rs_use_IF_OUT < dst_save_EX_OUT && RsAddr_IF_OUT == dst_addr_EX_OUT && dst_addr_EX_OUT != 0)
            || (rt_use_IF_OUT < dst_save_EX_OUT && RtAddr_IF_OUT == dst_addr_EX_OUT && dst_addr_EX_OUT != 0)
            || (rs_use_IF_OUT < dst_save_MEM_OUT && RsAddr_IF_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0)
            || (rt_use_IF_OUT < dst_save_MEM_OUT && RtAddr_IF_OUT == dst_addr_MEM_OUT && dst_addr_MEM_OUT != 0)
        ) begin
            bubble_if = 1;
        end else begin
            bubble_if = 0;
        end

        // reg control
        if (reset) begin
            reset_IF = 1;
            reset_ID = 1;
            reset_EX = 1;
            reset_MEM = 1;
            enable_IF = 1;
            enable_ID = 1;
            enable_EX = 1;
            enable_MEM = 1;
            enable_PC = 1;
        end else begin
            // IF
            reset_IF = 0;
            if (bubble_if) begin
                enable_IF = 0;
            end else begin
                enable_IF = 1;
            end

            // ID
            enable_ID = 1;
            if (bubble_if) begin
                reset_ID = 1;
            end else begin
                reset_ID = 0;
            end

            // EX
            reset_EX = 0;
            enable_EX = 1;

            // MEM
            reset_MEM = 0;
            enable_MEM = 1;

            // PC
            if (bubble_if) begin
                enable_PC = 0;
            end else begin
                enable_PC = 1;
            end
        end
    end

endmodule