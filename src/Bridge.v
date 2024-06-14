module Bridge(
    input interrupt,

    output [5:0] HWInt,

    input [31:0] cpu_m_data_addr,
    input [31:0] cpu_m_data_wdata,
    input [3:0] cpu_m_data_byteen,
    input [31:0] cpu_m_inst_addr,
    output reg [31:0] cpu_m_data_rdata,

    output reg [31:0] dm_m_data_addr,
    output reg [31:0] dm_m_data_wdata,
    output reg [3:0] dm_m_data_byteen,
    output reg [31:0] dm_m_inst_addr,
    input [31:0] dm_m_data_rdata,

    output reg [31:0] m_int_addr,
    output reg [3:0] m_int_byteen,

    output reg [31:2] tc0_addr,
    output reg tc0_enable,
    output reg [31:0] tc0_in,
    input [31:0] tc0_out,
    input tc0_irq,

    output reg [31:2] tc1_addr,
    output reg tc1_enable,
    output reg [31:0] tc1_in,
    input [31:0] tc1_out,
    input tc1_irq
);
    // TC0
    always @(*) begin
        if (cpu_m_data_addr >= 32'h00007f00 && cpu_m_data_addr <= 32'h00007f08) begin
            tc0_addr = {29'b0, cpu_m_data_addr[3:2]};
            tc0_in = cpu_m_data_wdata;
            cpu_m_data_rdata = tc0_out;
            if (cpu_m_data_byteen == 4'b1111) begin
                tc0_enable = 1;
            end else begin
                tc0_enable = 0;
            end
        end else begin
            tc0_enable = 0;
        end
    end

    // TC1
    always @(*) begin
        if (cpu_m_data_addr >= 32'h00007f10 && cpu_m_data_addr <= 32'h00007f18) begin
            tc1_addr = {29'b0, cpu_m_data_addr[3:2]};
            tc1_in = cpu_m_data_wdata;
            cpu_m_data_rdata = tc1_out;
            if (cpu_m_data_byteen == 4'b1111) begin
                tc1_enable = 1;
            end else begin
                tc1_enable = 0;
            end
        end else begin
            tc1_enable = 0;
        end
    end

    // DM
    always @(*) begin
        dm_m_data_addr = cpu_m_data_addr;
        dm_m_data_wdata = cpu_m_data_wdata;
        dm_m_inst_addr = cpu_m_inst_addr;
        if (cpu_m_data_addr >= 0 && cpu_m_data_addr <= 32'h00002fff) begin
            cpu_m_data_rdata = dm_m_data_rdata;
            dm_m_data_byteen = cpu_m_data_byteen;
        end else begin
            dm_m_data_byteen = 0;
        end
    end

    // INT
    always @(*) begin
        m_int_addr = cpu_m_data_addr;
        if (cpu_m_data_addr == 32'h00007f20) begin
            m_int_byteen = cpu_m_data_byteen;
        end else begin
            m_int_byteen = 0;
        end
    end

    assign HWInt = {3'b0, interrupt, tc1_irq, tc0_irq};

endmodule