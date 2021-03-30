`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2021 23:52:00
// Design Name: 
// Module Name: sim
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


module TOP_stim(

    );
    
    reg CLK;
    reg RESET;
    wire [7:0] rom_data;
    wire [7:0] rom_address;
    wire [7:0] BUS_DATA;
    wire [7:0] BUS_ADDR;

    wire bus_interrupts_raise_from_timer;
    wire [1:0] bus_interrupts_raise;
    wire [1:0] bus_interrupts_ack;
    assign bus_interrupts_raise = {bus_interrupts_raise_from_timer , 1'b0};
    wire bus_we;
    wire IR_LED;
    TopLevel wrap(
        //Standard Signals
        .CLK(CLK),
        .RESET(RESET),
        .switch(0),
        //IRTransmitter
        .IR_LED(IR_LED)
    );
    Processor microprocessor(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(bus_we),
        .ROM_ADDRESS(rom_address),
        .ROM_DATA(rom_data),
        .BUS_INTERRUPTS_RAISE(bus_interrupts_raise),
        .BUS_INTERRUPTS_ACK(bus_interrupts_ack)
    );
    Timer timer(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(bus_we),
        .BUS_INTERRUPT_RAISE(bus_interrupts_raise_from_timer),
        .BUS_INTERRUPT_ACK(bus_interrupts_ack[1])
    );
    ROM rom(
        .CLK(CLK),
        .DATA(rom_data),
        .ADDR(rom_address)
    );
    RAM ram(
        .CLK(CLK),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(bus_we)
    );
    initial begin
      CLK=0;
      //100MHz clock rate
      forever #5 CLK=~CLK;
    
    end
    initial begin
      RESET=0;
      #5 RESET=1;
      #5 RESET=0;
       

    end
    


endmodule
