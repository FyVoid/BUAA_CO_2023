module CP0(
    input clk,
    input reset,
    input enable,
    input [4:0] CP0Add,
    input [31:0] CP0In,
    input [31:0] VPC,
    input BDIn,
    input Exc,
    input [4:0] ExcCodeIn,
    input [5:0] HWInt,
    input EXLClr,
    output reg [31:0] CP0Out,
    output [31:0] EPCOut,
    output Req
);

    // SR           function
    // 0            IE(全局中断使能)
    // 1            EXL(核心态)
    // 15:10        IM(外部中断屏蔽掩码)
    reg [31:0] SR;
    // CAUSE        function
    // 15:10        IP(外部中断)
    // 31           BD(延迟漕标签)
    // 6:2          ExcCode(异常种类)
    reg [31:0] CAUSE;
    // 返回PC
    reg [31:0] EPC;

    always @(posedge clk) begin
        if (reset) begin
            SR <= 0;
            CAUSE <= 0;
            EPC <= 0;
        end
        else begin
            if (SR[1]) begin
                if (EXLClr) begin
                    SR[1] <= 0;
                end
                if (enable) begin
                    // SR
                    if (CP0Add == 12) begin
                        SR[1:0] <= CP0In[1:0];
                        SR[15:10] <= CP0In[15:10];
                    end
                    // EPC
                    else if (CP0Add == 14) begin
                        EPC <= CP0In;
                    end
                end
                CAUSE[15:10] <= HWInt;
            end else begin
                if (((HWInt & SR[15:10]) != 0) && SR[0]) begin
                    if (VPC != 0 || (VPC == 0 && ExcCodeIn == 4)) begin
                        CAUSE[15:10] <= HWInt;
                        CAUSE[6:2] <= 0;
                        CAUSE[31] <= BDIn;
                        if (BDIn) begin
                            EPC <= VPC - 4;
                        end
                        else begin
                            EPC <= VPC;
                        end
                        SR[1] <= 1;
                    end
                end else if (Exc) begin
                    if (BDIn) begin
                        EPC <= VPC - 4;
                    end else begin
                        EPC <= VPC;
                    end
                    CAUSE[6:2] <= ExcCodeIn;
                    CAUSE[15:10] <= HWInt;
                    CAUSE[31] <= BDIn;
                    SR[1] <= 1;
                end else begin
                    if (enable) begin
                        // SR
                        if (CP0Add == 12) begin
                            SR[0] <= CP0In[0];
                            SR[15:10] <= CP0In[15:10];
                        end
                        // EPC
                        else if (CP0Add == 14) begin
                            EPC <= CP0In;
                        end
                    end
                    CAUSE[15:10] <= HWInt;
                end
            end
        end
    end

    always @(*) begin
        if (CP0Add == 12) CP0Out = SR;
        else if (CP0Add == 13) CP0Out = CAUSE;
        else if (CP0Add == 14) CP0Out = EPC;
    end

    assign EPCOut = EPC;
    assign Req = ((| (HWInt & SR[15:10])) && ~SR[1] && SR[0] && VPC != 0)
                    || (Exc && ~SR[1])
                    ;
endmodule