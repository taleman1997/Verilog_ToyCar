`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2021 01:24:29
// Design Name: 
// Module Name: TOP
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


module IRTransmitter(
    input CLK,
    input RESET,
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    input [3:0] COMMAND,
    input mode,
    output IR_LED
 
    );

    wire send_packet;
    reg [3:0] currcom, nextcom;
    always@(posedge CLK) begin
        if(RESET)
            currcom<=4'b0000;
        else
            currcom<=nextcom;
    end
    
    always@(posedge CLK) begin
        if(RESET)
            nextcom<=4'b0000;
        else if (BUS_ADDR==8'h90 & BUS_WE)
            nextcom<=BUS_DATA[3:0];
    end
     
    wire [3:0] command;
    //Human controll is running when V17 slide switch is on, otherwise run the software program
    assign command = (mode) ? COMMAND : currcom;
    TenHz_cnt ten(
        .CLK(CLK),
        .RESET(RESET),
        .SEND_PACKET(send_packet)
    );
    
    IRTransmitterSM IR(
        .CLK(CLK),
        .RESET(RESET),
        .COMMAND(command),
        .SEND_PACKET(send_packet),
        .IR_LED(IR_LED)
    );
    
endmodule
