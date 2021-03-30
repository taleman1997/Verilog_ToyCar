`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh, School of Engineering
// Engineer: Zhilang Zhong      Liang Ma    Jianing Li 
// 
// Create Date: 2021/03/02 09:53:38
// Design Name: Digital System Laboratory 4/ Final assignment
// Module Name: RAM
// Project Name: 
// Target Devices: FPGA(Basys3)
// Tool Versions: 2015.2
// Description: 
// This is the RAM module. The function of this module is to read or write the the DATA memory
// Based on the processor control. More specific info about variable refer to RAM_DATA.txt.
// Dependencies: RAM_DATA.txt (careful with the file dir)
//              -------------------RAM address----------------------------
//              |    Addr             Data                                 |
//              |    -00              Data                                 |
//              |      |                |                                  |
//              |    -20              Memory                               |
//              |                                                          |
//              ------------------------------------------------------------
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RAM(
     //standard signals
    input CLK, 
    //BUS signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE
 );
    parameter RAMBaseAddr = 0;
    parameter RAMAddrWidth = 7; // 128 x 8-bits memory
    //Tristate
    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg RAMBusWE;
    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (RAMBusWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;
    //Memory
    reg [7:0] Mem [2**RAMAddrWidth-1:0];
    // Initialise the memory for data preloading, initialising variables, and declaring constants
    //please change the directory 
//    initial $readmemh("C:\\Xilinx_projects\\assessment2\\assessment2.srcs\\sources_1\\new\\RAM_DATA.txt", Mem);
    initial $readmemh("C:\\Users\\Hubert\\Desktop\\DSL_F\\assessment2\\assessment2.srcs\\sources_1\\new\\RAM_DATA.txt", Mem);
    
    //single port ram
    always@(posedge CLK) begin
        // Brute-force RAM address decoding. Think of a simpler way...
        if((BUS_ADDR >= RAMBaseAddr) & (BUS_ADDR < RAMBaseAddr + 128)) begin
            if(BUS_WE) begin
                Mem[BUS_ADDR[6:0]] <= BufferedBusData;
                RAMBusWE <= 1'b0;
            end 
            else
                RAMBusWE <= 1'b1;
        end 
        else
            RAMBusWE <= 1'b0;
        Out <= Mem[BUS_ADDR[6:0]];
    end
endmodule

