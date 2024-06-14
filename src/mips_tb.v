module mips_tb;
    
    reg clk;
    reg reset;

    mips m(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 1;
        reset = 1;
        #4 reset = 0;

        #10000 $finish;
    end

    initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, m);
    end

    always #1 clk = ~clk;

endmodule