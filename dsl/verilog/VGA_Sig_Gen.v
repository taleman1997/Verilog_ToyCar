`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UoE School of Engineering
// Engineer: Jianing LI(s1997612)
// ---------------------------------------------------------------------------------
// Create Date: 2021/02/19 20:10:25
// Design Name: 
// Module Name: VGA_Sig_Gen
// Project Name: Project Name: Digital System Laboratory Assessment_1
// Target Devices: BASYS 3
// Tool Versions: Vivado 2015.2
//----------------------------------------------------------------------------------
// Description: This is the VGA generator which is responsible to generate the VGA signal
//              It should be notice that the pixel clk is 25MHz. And as for different
//              monitor may have different pixel shift then the code for detect the display
//              range should be adjust based on the display image.
//              
//----------------------------------------------------------------------------------
// Dependencies: Generic_counter, Frame_Buffer, TOP
// Additional Comments: About the pixel shift in the border of the img. The adjust in
//                      code in detection. Line 135,141,148
//                      The color bias here is used to change color
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_Sig_Gen(
        input               CLK,
        input               RESET,
        //Colour Configuration Interface
        input               [3:0] COLOR_BIAS,
        input               [15:0] CONFIG_COLOURS,
        // Frame Buffer (Dual Port memory) Interface
        output              DPR_CLK,
        output              [14:0] VGA_ADDR,
        input               VGA_DATA,
        //VGA Port Interface
        output reg          VGA_HS,
        output reg          VGA_VS,
        output reg          [11:0] VGA_COLOUR
    );

    
    //Halve the clock to 25MHz to drive the VGA display.
//    reg VGA_CLK;                            // Later this reg will be used as triger out to drive the HS and VS counter
    
//    always@(posedge CLK) begin
//        if(RESET)
//        //if(1'b0)                           // Where DOES THIS RESET signal come from?
//            VGA_CLK <= 0;
//        else
//            VGA_CLK <= ~VGA_CLK;
//    end
    
    
    // Define VGA signal parameters e.g. Horizontal and Vertical display time, pulse widths, front and back porch widths etc.
    // Use the following signal parameters
    /*
    The value here is the number clks. Notation: (number of clks in this period , total number of clks)
    The sequence of these parameters. 
    begining(0,0) -> HTpw(96,96) -> Hbp(48,144) -> HTDisp(640,784) -> Hfp(16,800)
    begining(0,0) -> VTpw(2,2) -> Vbp(29,31) -> VTDisp(480,511) -> Vfp(10,521)
    Then based on the sequence above, we need adding some values for convenience
    */
    parameter HTs                      = 10'd800;              // Total Horizontal Sync Pulse Time
    parameter HTpw                     = 10'd96;               // Horizontal Pulse Width Time
    parameter HTDisp                   = 10'd640;              // Horizontal Display Time
    parameter Hbp                      = 10'd48;               // Horizontal Back Porch Time
    parameter Hfp                      = 10'd16;               // Horizontal Front Porch Time
    parameter HorzTimeToPulseWidthEnd  = 10'd96;
    parameter HorzTimeToBackPorchEnd   = 10'd144;
    parameter HorzTimeToDisplayTimeEnd = 10'd784;
    parameter HorzTimeToFrontPorchEnd  = 10'd800;
    
    parameter VTs                      = 10'd521;              // Total Vertical Sync Pulse Time
    parameter VTpw                     = 10'd2;                // Vertical Pulse Width Time
    parameter VTDisp                   = 10'd480;              // Vertical Display Time
    parameter Vbp                      = 10'd29;               // Vertical Back Porch Time
    parameter Vfp                      = 10'd10;               // Vertical Front Porch Time
    parameter VertTimeToPulseWidthEnd  = 10'd2;
    parameter VertTimeToBackPorchEnd   = 10'd31;
    parameter VertTimeToDisplayTimeEnd = 10'd511;
    parameter VertTimeToFrontPorchEnd  = 10'd521;
    
    // Something to fill in. Not sure
    
    
    
    // Define Horizontal and Vertical Counters to generate the VGA signals
    /*
    Based on the reference manual, the VGA display shows pixel by pixel and line by line. 
    It should first show the one whole horizontal line then the next.
    Then the tirger out of the HS signal should be the clk in VS signal
    */ 
    wire Horz_trig;
    wire Vert_trig;
    wire [9:0] HCounter;                         // The reg to store the HS counter value, the max is 799
    wire [9:0] VCounter;                         // The reg to store the VS counter value, the max is 520
    reg  [9:0] ADDRH;
    reg  [8:0] ADDRV;
    
//    initial begin
    
//    end
    
    //Create a process that assigns the proper horizontal and vertical counter values for raster scan of the display.
    
    Generic_counter # (.COUNTER_WIDTH(10), .COUNTER_MAX(799))
                     HorzCounter_1(
                     .CLK(CLK),
                     .RESET(1'b0),
                     .ENABLE(1'b1),
                     .TRIG_OUT(Horz_trig),
                     .COUNT(HCounter)
                     );

   Generic_counter # (.COUNTER_WIDTH(10), .COUNTER_MAX(520))
                     VertCounter_1(
                    .CLK(Horz_trig),
                    .RESET(1'b0),
                    .ENABLE(1'b1),
                    .TRIG_OUT(Vert_trig),
                    .COUNT(VCounter)
                     );
                     
    /*
     Need to create the address of the next pixel. Concatenate and tie the look ahead address to the frame buffer address. 
     */
     
     assign DPR_CLK = CLK;
     assign VGA_ADDR = {ADDRV[8:2], ADDRH[9:2]};  // Remove the two LSB bits to reduce the resolution 
     
     /*
     Create a process that generates the horizontal and vertical synchronisation signals, as well as the pixel
     colour information, using HCounter and VCounter. Do not forget to use CONFIG_COLOURS input to
     display the right foreground and background colours.
     */
     
      always@(posedge CLK) begin     
      
            if (HCounter < HorzTimeToPulseWidthEnd)
                VGA_HS <= 0;
            else
                VGA_HS <= 1;
                
            if (VCounter < VertTimeToPulseWidthEnd)
                VGA_VS <= 0;
            else
                VGA_VS <= 1;  
                     
            if((VertTimeToBackPorchEnd <= VCounter) && (VCounter < VertTimeToDisplayTimeEnd))
                ADDRV <= VCounter- VertTimeToBackPorchEnd;
            else
                ADDRV <= 0;
         
            if((HorzTimeToBackPorchEnd <= HCounter) && (HCounter < HorzTimeToDisplayTimeEnd))
                ADDRH <= HCounter-HorzTimeToBackPorchEnd;            
            else 
                ADDRH <= 0;
      
            if ((VertTimeToBackPorchEnd <= VCounter) && (VCounter < VertTimeToDisplayTimeEnd) && (HorzTimeToBackPorchEnd <= HCounter) &&(HCounter < HorzTimeToDisplayTimeEnd)) begin
                if(VGA_DATA)begin
                    VGA_COLOUR <= {COLOR_BIAS,CONFIG_COLOURS[15:8]}; 
                end
                else begin
                    VGA_COLOUR <= {COLOR_BIAS,CONFIG_COLOURS[7:0]};  
                end
            end
            else
                VGA_COLOUR <= 8'h00;
            
            // Finally, tie the output of the frame buffer to the colour output VGA_COLOUR.
      end
      

  
    
    
endmodule
