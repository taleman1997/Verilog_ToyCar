`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2021 11:54:34
// Design Name: 
// Module Name: IRTransimitterSM
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


module IRTransmitterSM(
    //Standard Signals
    input CLK,
    input RESET,
    //Bus Interface Signals
    input [3:0] COMMAND,
    input SEND_PACKET,
    //IF LED signal
    output reg IR_LED

    );
    //blue-coded cars
    parameter StartBurstSize = 191;
    parameter CarSelectBurstSize = 47;
    parameter GapSize = 25;
    parameter AssertBurstSize = 47;
    parameter DeAssertBurstSize = 22;
    parameter clk_count=1387;//almost 36kHz clock rate


    
    /*
    Generate the pulse signal here from the main clock running at 100MHz to generate the right frequency for
    the car in question e.g. 36KHz for BLUE coded cars
    */
    reg [27:0] cnt;
    reg newCLK;
    always@(posedge CLK) begin
        if(RESET) begin
            cnt<=0;
            newCLK<=0;
        end
        else begin
            //almost 36kHz clock rate
            if(cnt==clk_count) begin
                cnt<=0;
                newCLK<=~newCLK;
            end
            else
                cnt<=cnt+1;
        end 
    end

    /*
    Simple state machine to generate the states of the packet i.e. Start, Gaps, Right Assert or De-Assert, Left
    Assert or De-Assert, Backward Assert or De-Assert, and Forward Assert or De-Assert
    */
    reg [7:0] seq[10:0];
    
    always@(posedge SEND_PACKET) begin
        case(COMMAND)
            //right
            4'b0001: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=AssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=DeAssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=DeAssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=DeAssertBurstSize;
            end
            //left
            4'b0010: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=DeAssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=AssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=DeAssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=DeAssertBurstSize;

            end
            //backward
            4'b0100: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=DeAssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=DeAssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=AssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=DeAssertBurstSize;         

            end
            //forward
            4'b1000: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=DeAssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=DeAssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=DeAssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=AssertBurstSize;
            end   
            //forward and right
            4'b1001: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=AssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=DeAssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=DeAssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=AssertBurstSize;
            end   
            //forward and left
            4'b1010: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=DeAssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=AssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=DeAssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=AssertBurstSize;
            end   
            //backward and left
            4'b0110: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=DeAssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=AssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=AssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=DeAssertBurstSize;
            end  
            //backward and right
            4'b0101: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=AssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=DeAssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=AssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=DeAssertBurstSize;
            end  
            //No response
            default: begin
                seq[0]<=StartBurstSize;
                seq[1]<=GapSize;
                seq[2]<=CarSelectBurstSize;
                seq[3]<=GapSize;
                seq[4]<=DeAssertBurstSize;
                seq[5]<=GapSize;
                seq[6]<=DeAssertBurstSize;
                seq[7]<=GapSize;
                seq[8]<=DeAssertBurstSize;
                seq[9]<=GapSize;
                seq[10]<=DeAssertBurstSize;
            end
        endcase
    end
    
    // Finally, tie the pulse generator with the packet state to generate IR_LED
    reg [7:0] count;
    reg [3:0] i;

    //Counting for each seq[i], to generate a generic packet
    always@(posedge newCLK) begin
        if(SEND_PACKET==1) begin
            if(count==seq[i]-1 & i<11) begin
                i<=i+1;
                count<=0;
            end
            //if i>=11, stop counting,
            else if(i<11)
                count<=count+1;
        end
        else begin
            count<=0;
            i<=0;
        end
    end
    
    //Sending IR signal
    always@(newCLK) begin
        if(SEND_PACKET==1 & i%2==0 & newCLK==1)
            IR_LED<=1; //instructions
        else 
            IR_LED<=0; //no instructions
    end

endmodule
