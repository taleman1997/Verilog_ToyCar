`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh, School of Engineering
// Engineer: Zhilang Zhong      Liang Ma    Jianing Li 
// 
// Create Date: 2021/03/02 10:43:51
// Design Name: Digital System Laboratory 4/ Final assignment
// Module Name: Processor
// Project Name: 
// Target Devices: FPGA(Basys3)
// Tool Versions: 2015.2
// -------------------------I/O-----------------------------------------------------
// Two registers for math:
// - IN_A                       VEC[7:0]    INPUT  
// - IN_B                       VEC[7:0]    INPUT   
// - ALU_Op_Code                VEC[1:0]    INPUT   operation code to select the operation
// - OUT_RESULT                 VEC[7:0]    OUTPUT  output result
// This is the algorithm look up table. In this module we have a series of operations and some 
// extra operations for color logic generation.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    //standard signals
    input CLK,
    input RESET,
    //I/O
    input [7:0] IN_A,
    input [7:0] IN_B,
    input [3:0] ALU_Op_Code,
    output [7:0] OUT_RESULT
    );
    
    reg [7:0] Out;
    //Arithmetic Computation
    always@(posedge CLK) begin
        if(RESET)
            Out <= 0;
        else begin 
            case (ALU_Op_Code)
                //Maths Operations
                //Add A + B 
                4'h0: Out <= IN_A + IN_B;
                //Subtract A - B
                4'h1: Out <= IN_A - IN_B;
                //Multiply A * B
                4'h2: Out <= IN_A * IN_B;
                //Shift Left A << 1
                4'h3: Out <= IN_A << 1;
                //Shift Right A >> 1
                4'h4: Out <= IN_A >> 1;
                //Increment A+1
                4'h5: Out <= IN_A + 1'b1;
                //Increment B+1
                4'h6: Out <= IN_B + 1'b1;
                //Decrement A-1
                4'h7: Out <= IN_A - 1'b1;
                //Decrement B+1
                4'h8: Out <= IN_B - 1'b1;
                // In/Equality Operations
                //A == B
                4'h9: Out <= (IN_A == IN_B) ? 8'h01 : 8'h00;
                //A > B
                4'hA: Out <= (IN_A > IN_B) ? 8'h01 : 8'h00;
                //A < B
                4'hB: Out <= (IN_A < IN_B) ? 8'h01 : 8'h00;
                // Operations for chequered pattern
                // Operations in rows
                4'hC: Out <= ((IN_A >= IN_B) && (IN_A <= IN_B +39)) ? 8'h01 : 8'h00;     
                // Operations in columns
                4'hD: Out <= ((IN_A >= IN_B) && (IN_A <= IN_B +52)) ? 8'h01 : 8'h00;     
                //for one color (9 squares)
                4'hE: Out <= (IN_A == IN_B) ? 8'h00 : 8'h01;                        
                 //for one color (mouse pixel)
                4'hF: Out <= (IN_A[0] ^ IN_B[0]) ? 8'h01 : 8'h00;                       
                //Default A
                default: Out <= IN_A;
            endcase
        end
    end
    assign OUT_RESULT = Out;
    
    
    
endmodule
