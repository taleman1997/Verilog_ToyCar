`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/09 19:09:34
// Design Name: 
// Module Name: TOP_tb
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


module TOP_tb(

    );
    reg CLK;
    reg RESET;
    wire HS;
    wire VS;
    wire [11:0] COLOUR_OUT;

    TopLevel uut (
             .CLK(CLK), 
             .RESET(RESET),
             .HS(HS),
             .VS(VS),
             .COLOUR_OUT(COLOUR_OUT)
             );
    
    
    initial begin
        RESET = 0;
        CLK = 0;        
        forever begin
            #5 CLK =~CLK;
        end
    end
    

    
    
endmodule
