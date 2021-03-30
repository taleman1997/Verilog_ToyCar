`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2021 10:44:07
// Design Name: 
// Module Name: TenHz_cnt
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


module TenHz_cnt(
    input CLK,
    input RESET,
    output reg SEND_PACKET
    );
    
    reg [28:0] cnt;
    always@(posedge CLK) begin
        if(RESET) begin
            cnt<=0;
            SEND_PACKET<=0;
        end
        else begin
            //10 Hz counter
            if(cnt==4999999) begin
                cnt<=0;
                SEND_PACKET<=~SEND_PACKET;
            end
            else begin
                cnt<=cnt+1;
            end
        end 
    end

    



endmodule
