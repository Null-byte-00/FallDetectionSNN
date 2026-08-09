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


module LIF_Neuron#(
    parameter THRESHOLD = 8'sd50
    )
    (
    input [7:0] input_current,
    input clk,
    output reg output_spike,
 
    reg signed [7:0] membrane_potential,
    reg signed [7:0] sum
    );
    
    always @(posedge clk) begin
        sum <= (input_current + membrane_potential);
        membrane_potential <= sum;
        if (membrane_potential >= THRESHOLD) begin
            output_spike <= 1;
            membrane_potential <= 8'sd0;
        end else begin
            output_spike <= 0;
        end
    end
endmodule
