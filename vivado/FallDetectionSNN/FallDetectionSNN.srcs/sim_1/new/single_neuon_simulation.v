`timescale 1ns / 1ps

module single_neuron_simulation;

    reg signed [7:0] input_current;
    reg clk;
    reg reset;

    wire output_spike;

    LIF_Neuron #(
        .THRESHOLD(16'sd50)
    ) dut (
        .input_current(input_current),
        .clk(clk),
        .reset(reset),
        .output_spike(output_spike)
    );

    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end

    initial begin

        reset = 1;
        input_current = 0;

        #20;

        reset = 0;

        input_current = 8'sd15;

        #50;

        input_current = 8'sd0;

        #50;

        input_current = 8'sd40;

        #30;



        input_current = -8'sd10;

        #40;

        reset = 1;

        #20;

        reset = 0;
        input_current = 0;

        #20;

        $finish;

    end


    initial begin

        $monitor(
            "time=%0t | reset=%b | input=%d | membrane=%d | spike=%b",
            $time,
            reset,
            input_current,
            dut.membrane_potential,
            output_spike
        );

    end

endmodule