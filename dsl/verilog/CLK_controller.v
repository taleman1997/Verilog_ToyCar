`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh, School of Engineering
// Engineer: Jianing Li (s1997612) 
// Design Name: Digital System Laboratory 4/ Final assignment
// Module Name: Processor
// Project Name: 
// Target Devices: FPGA(Basys3)
// Tool Versions: 2015.2
// Description: This is the module contains all the counter used in the project. For
//              VGA signal, this module generate an 25MHz.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLK_controller(
    input               CLK,                    // The input CLK signal from board 100MHz.
    output              DOUBLE_TRIG             // The output CLK signal for VGA interface 25MHz.
    );
    
    // This counter is to slow down the frequency to 25MHz
    wire single_counter;
    wire single_trig;
    Generic_counter # (.COUNTER_WIDTH(1),.COUNTER_MAX(1))
                       singlecounter(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(single_trig),
                       .COUNT(single_counter)
                       );
    
    
    // This counter is to slow down the frequency to 25MHz
    wire [1:0] double_counter;
    wire double_tirg;
    Generic_counter # (.COUNTER_WIDTH(2),.COUNTER_MAX(3))
                       doublecounter(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(double_tirg),
                       .COUNT(double_counter)
                       );
    
    // This counter is to slow down the frequency to 1MHz                   
    wire [4:0] mega_count;
    wire mega_trig;
    Generic_counter # (.COUNTER_WIDTH(5),.COUNTER_MAX(24))
                       megacounter(
                       .CLK(double_tirg),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(mega_trig),
                       .COUNT(mega_count)
                       );
     
    // This counter is to slow down the frequency to 1Hz              
    wire [16:0] second_count;
    wire second_trig;
    Generic_counter # (.COUNTER_WIDTH(17),.COUNTER_MAX(99999))
                       secondcounter(
                       .CLK(mega_trig),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(second_trig),
                       .COUNT(second_count)
                       );
                       
    // This is the colour adder with 1Hz frequency             
    wire [7:0] colour_count;
    wire colour_trig;
    Generic_counter # (.COUNTER_WIDTH(8),.COUNTER_MAX(255))
                       colouradder(
                       .CLK(second_trig),
                       .RESET(1'b0),
                       .ENABLE(1'b1),
                       .TRIG_OUT(colour_trig),
                       .COUNT(colour_count)
                       );
                       
    assign DOUBLE_TRIG = double_tirg;
    
endmodule
