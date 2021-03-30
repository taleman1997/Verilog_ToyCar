`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh, School of Engineering
// Engineer: Jianing Li (s1997612) 
// Design Name: Digital System Laboratory 4/ Final assignment
// Module Name: Processor
// Project Name: 
// Target Devices: FPGA(Basys3)
// Tool Versions: 2015.2
//------------------------------------------------------------------------------------------
// Description: This is the frame buffer which stroe the data from the bus and transfer
//              the pixel data to the VGA_Sig_Gen. We can use the txt file to initialize 
//              the frame buffer. The buffer have two ports which can operate in two different
//              cloc signals.
//-------------------PORTS------------------------------------------------------------------
// PORT_A: is used for the processor write and read
// PORT_B: is used for the VGA_Sig_Gen.
//-------------------IOs--------------------------------------------------------------------
// PORT_A
// - COLOR_SW                           INPUT  
// - A_CLK                              INPUT   
// - A_ADDR                VEC[14:0]    INPUT  8 + 7 bits = 15 bits hence[14:0]
// - A_DATA_IN                          INPUT  output result
// - A_WE                               INPUT  Write Enablt signal
// - output                REG          OUTPUT 
// PORT_B
// - B_CLK                              INPUT
// - B_ADDR                VEC[14:0]    INPUT addr from the VGA_Sig_Gen
// - B_DATA                             OUTPUT
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Frame_Buffer(
    // Port A - Read/Write
    input               COLOR_SW,
    input               A_CLK,
    input               [14:0] A_ADDR,          // 8 + 7 bits = 15 bits hence[14:0]
    input               A_DATA_IN,              // Pixel Data In
    output        reg   A_DATA_OUT,
    input               A_WE,                   // Write Enablt signal
    // Port B - Read Only
    input               B_CLK,
    input               [14:0] B_ADDR,          // Pixel Data Out
    output        reg   B_DATA
    );
    
    // A 256 x 128 1-bit memory to hold frame data
    // The LSBs of the address correspond to the X axis, and the MSBs to the Y axis
    // For this is a 1 - bit memory, the width for each reg is 1 then [0:0]
    // It should have 256 x 128 in the Mem then 2^15 = 256 x 128
    reg [0:0] Mem [2**15-1:0];
    initial $readmemh("C:\\Users\\Hubert\\Desktop\\DSL_F\\assessment2\\assessment2.srcs\\sources_1\\new\\mem_zeros.txt", Mem);


    // Port A - Read/Write e.g. to be used by microprocessor
    always@(posedge A_CLK) begin
        if(A_WE)                                                            // If the write avaliable signal is positive
            Mem[A_ADDR] <= A_DATA_IN ^ COLOR_SW;                                       // Then A_DATA_IN value will be put in memory at location A_ADDR
        A_DATA_OUT <= Mem[A_ADDR];                                          // Output the value at the same location
    end
    
    // Port B - Read Only e.g. to be read from the VGA signal generator module for display
    always@(posedge B_CLK)
        B_DATA <= Mem[B_ADDR];
    
endmodule
