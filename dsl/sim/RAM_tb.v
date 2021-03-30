`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/09 14:38:10
// Design Name: 
// Module Name: RAM_tb
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


module RAM_tb(

    );
    
//    module RAM(
//            //standard signals
//            input               CLK,
//            //BUS signals
//            inout               [7:0] BUS_DATA,
//            input               [7:0] BUS_ADDR,
//            input               BUS_WE
//    );

    reg CLK;
    
    wire [7:0] BUS_DATA;
    reg [7:0] BUS_DATA_reg;
    reg BUS_DATA_en;
    
    reg [7:0] BUS_ADDR;
    reg BUS_WE;
    
    
    assign BUS_DATA = BUS_DATA_en ? BUS_DATA_reg : 1'bz; 
    
    RAM uut (
            .CLK(CLK),
            .BUS_DATA(BUS_DATA),
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE)
    );
    
    initial begin
        CLK = 0;
        forever begin
            #5 CLK = ~CLK;
        end
    end
    
    initial begin
        BUS_WE = 0;
        BUS_DATA_en = 0;
        BUS_DATA_reg = 0;
        BUS_ADDR = 0;
        
        #50 BUS_WE = 1;
        #50 BUS_ADDR = 8'h00;
        #50 BUS_WE = 0; BUS_DATA_en = 1;
        #50 BUS_ADDR = 8'h03;
        #50 BUS_DATA_reg = 8'h09;
        #50 BUS_WE = 1; BUS_DATA_en = 1;
        #50 BUS_ADDR = 8'h02;
        
    end
    
    
endmodule
