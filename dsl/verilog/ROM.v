`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh, School of Engineering
// Engineer: Zhilang Zhong      Liang Ma    Jianing Li 
// 
// Create Date: 2021/03/02 09:53:38
// Design Name: Digital System Laboratory 4/ Second assignment
// Module Name: Processor
// Project Name: 
// Target Devices: FPGA(Basys3)
// Tool Versions: 2015.2
// Description: 
// Read from instruction memory
// Dependencies: 
// ROM_DATA.txt
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ROM(
    //standard signals
    input CLK,
    //BUS signals
    output reg [7:0] DATA,
    input [7:0] ADDR
 );
    parameter RAMAddrWidth = 8;
    //Memory
    reg [7:0] ROM [2**RAMAddrWidth-1:0];
    // Load program
    //please change the directory 
//    initial $readmemh("C:\\Xilinx_projects\\assessment2\\assessment2.srcs\\sources_1\\new\\ROM_DATA.txt", ROM);
        initial $readmemh("C:\\Users\\Hubert\\Desktop\\DSL_F\\assessment2\\assessment2.srcs\\sources_1\\new\\ROM_DATA.txt", ROM);
    //single port ram
    always@(posedge CLK)
        DATA <= ROM[ADDR];
        
        
        

endmodule
