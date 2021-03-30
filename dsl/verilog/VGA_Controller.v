`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh, School of Engineering
// Engineer: Jianing Li (s1997612) 
// Design Name: Digital System Laboratory 4/ Final assignment
// Module Name: Processor
// Project Name: 
// Target Devices: FPGA(Basys3)
// Tool Versions: 2015.2
// Description: 
// -----------------------------------------------------------------------------------
// This is the VGA controller to collect the bus data to the regster, package to the 
// coordinate index and send to the frame buffer. The list below is the specific addr
// for different data.
// 0xB0: H coordinate
// 0xB1: V coordinate
// 0xB2: pixel data
// -------------------------------------------------------------------------------------
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_Controller(
    input           clk,
    input           [7:0] addr,
    input           [7:0] data,
    input           BUS_WE,
    output          reg [14:0]buffer_addr,
    output          reg pixel_out
    );
    
    reg[7:0] H_coordinate;
    reg[7:0] V_coordinate;    
    
    reg[7:0] pixel_data;
    reg pixel_signal;
    reg[14:0] buffer_index;
    
    //initial the buffer for the test bench
    initial begin
        H_coordinate = 8'h00;
        V_coordinate = 8'h00;
        pixel_data = 8'h00;
        pixel_signal = 1;
        buffer_index = 15'b000000000000000;
    end
    
    always@(posedge clk)begin
        if((addr == 8'hB0) && (BUS_WE != 1'b0))  
            H_coordinate <= data;  
    end
    
    
    always@(posedge clk)begin
        if((addr == 8'hB1) && (BUS_WE != 1'b0))  
            V_coordinate <= data;    
    end
    
    // as teh pixel data is collected, package the coordinate to the frame buffer.
    always@(posedge clk)begin
        if((addr == 8'hB2) && (BUS_WE != 1'b0))begin
            pixel_out <= data[0];
            buffer_addr <= {V_coordinate[6:0], H_coordinate[7:0]};
        end
    end
    
endmodule
