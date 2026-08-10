`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2026 03:51:25 AM
// Design Name: 
// Module Name: LIF_Neuron
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LIF_Neuron #(
    parameter signed [7:0] THRESHOLD = 8'sd50
)(
    input  wire signed [7:0] input_current,
    input  wire              clk,
    input  wire              reset,
    output reg               output_spike
);

    reg signed [8:0] membrane_potential;
    reg signed [8:0] next_membrane;

    always @(*) begin
        next_membrane =
            membrane_potential + input_current;
    end

    always @(posedge clk) begin

        if (reset) begin
            membrane_potential <= 9'sd0;
            output_spike       <= 1'b0;
        end
        else begin

            if (next_membrane >= THRESHOLD) begin
                output_spike       <= 1'b1;
                membrane_potential <= 9'sd0;
            end
            else begin
                output_spike       <= 1'b0;
                membrane_potential <= next_membrane;
            end

        end
    end

endmodule