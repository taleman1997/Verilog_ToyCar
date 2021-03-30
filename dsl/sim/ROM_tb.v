`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/09 15:42:28
// Design Name: 
// Module Name: ROM_tb
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


module ROM_tb(

    );
    
    reg CLK;
    reg [7:0] ADDR;
    wire [7:0] DATA;
    
    ROM uut(
        .CLK(CLK),
        .DATA(DATA),
        .ADDR(ADDR)
    );
    
    initial begin
        CLK = 0;
        forever begin
            #5 CLK = ~CLK;
        end
    end
    
    initial begin
        ADDR = 8'h00;
        # 50 ADDR = 8'h00;
        # 50 ADDR = 8'h01;
        # 50 ADDR = 8'h02;
        # 50 ADDR = 8'h03;
        # 50 ADDR = 8'h04;
        # 50 ADDR = 8'h05;
        # 50 ADDR = 8'h06;
    end
endmodule
