module mips(
    input clk,
    input reset,
    input interrupt,
    output [31:0] macroscopic_pc,

    output [31:0] i_inst_addr,
    input [31:0] i_inst_rdata,

    output [31:0] m_data_addr,
    input [31:0] m_data_rdata,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,

    output [31:0] m_int_addr,
    output [3:0] m_int_byteen,

    output [31:0] m_inst_addr,

    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,

    output [31:0] w_inst_addr
);


    wire [31:0] cpu_m_data_addr;
    wire [31:0] cpu_m_data_wdata;
    wire [3:0] cpu_m_data_byteen;
    wire [31:0] cpu_m_inst_addr;

    wire cpu_w_grf_we;
    wire [4:0] cpu_w_grf_addr;
    wire [31:0] cpu_w_grf_wdata;
    wire [31:0] cpu_w_inst_addr;

    CPU cpu(
        .clk(clk),
        .reset(reset),

        .HWInt(HWInt),

        .i_inst_addr(i_inst_addr),
        .i_inst_rdata(i_inst_rdata),

        .m_data_rdata(bridge_m_data_rdata),
        .m_data_addr(cpu_m_data_addr),
        .m_data_wdata(cpu_m_data_wdata),
        .m_data_byteen(cpu_m_data_byteen),
        .m_inst_addr(cpu_m_inst_addr),

        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),
        .w_inst_addr(w_inst_addr),

        .macroscopic_pc(macroscopic_pc)
    );

    wire [5:0] HWInt;

    wire [31:0] bridge_m_data_rdata;

    wire [31:2] tc0_addr;
    wire tc0_enable;
    wire [31:0] tc0_in;

    wire [31:2] tc1_addr;
    wire tc1_enable;
    wire [31:0] tc1_in;
    Bridge bridge(
        .interrupt(interrupt),

        .HWInt(HWInt),

        .cpu_m_data_addr(cpu_m_data_addr),
        .cpu_m_data_wdata(cpu_m_data_wdata),
        .cpu_m_data_byteen(cpu_m_data_byteen),
        .cpu_m_inst_addr(cpu_m_inst_addr),
        .cpu_m_data_rdata(bridge_m_data_rdata),

        .dm_m_data_addr(m_data_addr),
        .dm_m_data_wdata(m_data_wdata),
        .dm_m_data_byteen(m_data_byteen),
        .dm_m_inst_addr(m_inst_addr),
        .dm_m_data_rdata(m_data_rdata),

        .m_int_addr(m_int_addr),
        .m_int_byteen(m_int_byteen),

        .tc0_addr(tc0_addr),
        .tc0_enable(tc0_enable),
        .tc0_in(tc0_in),
        .tc0_out(tc0_out),
        .tc0_irq(tc0_irq),

        .tc1_addr(tc1_addr),
        .tc1_enable(tc1_enable),
        .tc1_in(tc1_in),
        .tc1_out(tc1_out),
        .tc1_irq(tc1_irq)
    );

    wire [31:0] tc0_out;
    wire tc0_irq;
    TC tc0(
        .clk(clk),
        .reset(reset),
        .Addr(tc0_addr),
        .WE(tc0_enable),
        .Din(tc0_in),
        .Dout(tc0_out),
        .IRQ(tc0_irq)
    );

    wire [31:0] tc1_out;
    wire tc1_irq;
    TC tc1(
        .clk(clk),
        .reset(reset),
        .Addr(tc1_addr),
        .WE(tc1_enable),
        .Din(tc1_in),
        .Dout(tc1_out),
        .IRQ(tc1_irq)
    );

endmodule