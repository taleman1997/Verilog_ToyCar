`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh, School of Engineering
// Engineer: Zhilang Zhong      Liang Ma    Jianing Li 
// 
// Create Date: 09.03.2021 15:44:48
// Design Name: Digital System Laboratory 4/ Final assignment
// Module Name: wrapper
// Target Devices: FPGA(Basys3)
// Tool Versions: 2015.2
// Description: 
// ----------------------------VGA--------------------------------------------------------
// The VGA part draw the nine-square background image to the screen and update the mouse positon
// with the inverse color. The switchs(SW15-SW12) is used to change the color of the background.
// Switch 11 is used to change the position of the color.
// ---------------------------MOUSE-------------------------------------------------------
// Use the switch T2 can change the sensitivity of the mouse.
// Dependencies: IRTransmitter, Processor, RAM, ROM, Timer, VGA_Controller, VGA_Sig_Gen,
//               Frame_Buffer
// ---------------------------IR Transmitter----------------------------------------------
// Sending the movement command by reading the coordinates x and y of mouse so that it can be identified which region is currently located, 
// then send the corresponding signal by IR transitter led to the toy car.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 

module TopLevel( 
    //Standard Signals
    input CLK,
    input RESET,
    input [3:0] COMMAND,
    input switch,
    //IO - Mouse side
    input SENSITIVITY,
    inout CLK_MOUSE,
    inout DATA_MOUSE,
    //IRTransmitter
    output IR_LED,
    //VGA
    input           [3:0] COLOR_BIAS,
    input           COLOR_SW,
    output          HS,
    output          VS,
    output          [11:0] COLOUR_OUT
    );
   //------------------------VGA--------------------------
    //wire connection for VGA_Sig_Gen and Frame_Buffer
    wire double_tirg;
    wire vga_drp_clk;
    wire pixel_sig_from_buffer_B;
    wire [14:0] interface_VGA_ADDR_output;
    wire [15:0] interface_CONFIG_COLOURS;
    wire [7:0]  interface_colour_output; 
    wire [14:0] buffer_index;
    wire a_data_out;
    wire pixel;
    
    assign interface_CONFIG_COLOURS = 16'b1111000000001111;
   //------------------------VGA--------------------------
   
    //wire connection for Processor ROM and RAM 
    wire [7:0] BUS_DATA;
    wire [7:0] BUS_ADDR;
    wire [7:0] rom_address;
    wire [7:0] rom_data;
    wire BUS_WE;
    wire bus_interrupts_raise_from_timer;
    wire bus_interrupts_raise_from_mouse;
    wire [1:0] bus_interrupts_raise;
    wire [1:0] bus_interrupts_ack;
    
    assign bus_interrupts_raise = {bus_interrupts_raise_from_timer, bus_interrupts_raise_from_mouse};
    
    //------------------------IR transmitter------------------------
    //*Push up the slide-switch V17 can enter the human-control mode*
    //Please holding the board and point to the toy car, 
    //note: the BTNL button is forward instead of turn left, the BTNR button is backward in instead of turn right...
    IRTransmitter IR_TOP(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .IR_LED(IR_LED),
        .mode(switch), // V17 slide-switch, 1: push button 0: mouse control
        .COMMAND(COMMAND)
    );
    //------------------------IR transmitter------------------------

    Processor microprocessor(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .ROM_ADDRESS(rom_address),
        .ROM_DATA(rom_data),
        .BUS_INTERRUPTS_RAISE(bus_interrupts_raise),
        .BUS_INTERRUPTS_ACK(bus_interrupts_ack)
    );
    
    RAM ram(
        .CLK(CLK),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE)
    );
     
    ROM rom(
        .CLK(CLK),
        .DATA(rom_data),
        .ADDR(rom_address)
    );
    
    Timer timer(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .BUS_INTERRUPT_RAISE(bus_interrupts_raise_from_timer),
        .BUS_INTERRUPT_ACK(bus_interrupts_ack[1])
    );
    
    
    //------------------------mouse------------------------
    MouseTransceiver MD(
        .SENSITIVITY(SENSITIVITY),
        .RESET(RESET),
        .CLK(CLK),
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .MOUSE_INTERRUPTS_RAISE(bus_interrupts_raise_from_mouse),
        .MOUSE_INTERRUPTS_ACK(bus_interrupts_ack[0])
    );
    //------------------------mouse------------------------
 
    //------------------------VGA--------------------------
    VGA_Controller   submodule_vga_controller(
        .clk(CLK),
        .addr(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .data(BUS_DATA),
        .buffer_addr(buffer_index),
        .pixel_out(pixel)
    );
    
    CLK_controller   submodule_controller(
        .CLK(CLK),
        .DOUBLE_TRIG(double_tirg)
    );
    
    VGA_Sig_Gen      submodule_vga(
        .CLK(double_tirg),
        .COLOR_BIAS(COLOR_BIAS),
        .CONFIG_COLOURS(interface_CONFIG_COLOURS),
        .DPR_CLK(vga_drp_clk),
        .VGA_ADDR(interface_VGA_ADDR_output),
        .VGA_DATA(pixel_sig_from_buffer_B),
        .VGA_HS(HS),
        .VGA_VS(VS),
        .VGA_COLOUR(COLOUR_OUT)
    );
    
    Frame_Buffer    submodule_buffer(
        .COLOR_SW(COLOR_SW),
        .A_CLK(CLK),
        .A_ADDR(buffer_index),          
        .A_DATA_IN(pixel),              
        .A_DATA_OUT(a_data_out),
        .A_WE(1'b1),                   
        .B_CLK(vga_drp_clk),
        .B_ADDR(interface_VGA_ADDR_output),          
        .B_DATA(pixel_sig_from_buffer_B)
    );     
    //------------------------VGA--------------------------
    
    
endmodule
