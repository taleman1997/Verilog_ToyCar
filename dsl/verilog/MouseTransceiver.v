`timescale 1ns / 1ps

module MouseTransceiver(
    //Standard Inputs
    input RESET,
    input CLK,
    input SENSITIVITY,
    //IO - Mouse side
    inout CLK_MOUSE,
    inout DATA_MOUSE,
    //Bus signals
    output [7:0] BUS_DATA,
    input  [7:0] BUS_ADDR,
    //Mouse data information
    output reg [3:0] MouseStatus,
    output reg [7:0] MouseX,
    output reg [7:0] MouseY,
    //Interrupt output
    output MOUSE_INTERRUPTS_RAISE,   
    input  MOUSE_INTERRUPTS_ACK
 );
    //X, Y Limits of Mouse Position e.g. VGA Screen with 160 x 120 resolution
    parameter [7:0] MouseLimitX = 160;
    parameter [7:0] MouseLimitY = 120;
    //Mouse Driver Base Address in the Memory Map
    parameter [7:0] MouseBaseAddr = 8'hA0;         //A0 A1 A2
    /////////////////////////////////////////////////////////////////////
    //Clk
    reg ClkMouseIn;
    wire ClkMouseOutEnTrans;
    //Data
    wire DataMouseIn;
    wire DataMouseOutTrans;
    wire DataMouseOutEnTrans;
    //Clk Output - can be driven by host or device
    assign CLK_MOUSE = ClkMouseOutEnTrans ? 1'b0 : 1'bz;
    //Clk Input
    assign DataMouseIn = DATA_MOUSE;
    //Clk Output - can be driven by host or device
    assign DATA_MOUSE = DataMouseOutEnTrans ? DataMouseOutTrans : 1'bz;
    //BUS data assign
    assign BUS_DATA = OUT_EN ? OUT : 8'hzz;
    /////////////////////////////////////////////////////////////////////
    //This section filters the incoming Mouse clock to make sure that
    //it is stable before data is latched by either transmitter
    //or receiver modules
    reg [7:0]MouseClkFilter;
    always@(posedge CLK) begin
        if(RESET)
            ClkMouseIn <= 1'b0;
        else begin
            //A simple shift register
            MouseClkFilter[7:1] <= MouseClkFilter[6:0];
            MouseClkFilter[0] <= CLK_MOUSE;
            //falling edge
            if(ClkMouseIn & (MouseClkFilter == 8'h00))
                ClkMouseIn <= 1'b0;
            //rising edge
            else if(~ClkMouseIn & (MouseClkFilter == 8'hFF))
                ClkMouseIn <= 1'b1;
        end
    end
    ///////////////////////////////////////////////////////
    //Instantiate the Transmitter module
    wire SendByteToMouse;
    wire ByteSentToMouse;
    wire [7:0] ByteToSendToMouse;
    MouseTransmitter T(
        //Standard Inputs
        .RESET (RESET),
        .CLK(CLK),
        //Mouse IO - CLK
        .CLK_MOUSE_IN(ClkMouseIn),
        .CLK_MOUSE_OUT_EN(ClkMouseOutEnTrans),
        //Mouse IO - DATA
        .DATA_MOUSE_IN(DataMouseIn),
        .DATA_MOUSE_OUT(DataMouseOutTrans),
        .DATA_MOUSE_OUT_EN(DataMouseOutEnTrans),
        //Control
        .SEND_BYTE(SendByteToMouse),
        .BYTE_TO_SEND(ByteToSendToMouse),
        .BYTE_SENT(ByteSentToMouse)
    );
    ///////////////////////////////////////////////////////
    //Instantiate the Receiver module
    wire ReadEnable;
    wire [7:0] ByteRead;
    wire [1:0] ByteErrorCode;
    wire ByteReady;
    MouseReceiver R(
        //Standard Inputs
        .RESET(RESET),
        .CLK(CLK),
        //Mouse IO - CLK
        .CLK_MOUSE_IN(ClkMouseIn),
        //Mouse IO - DATA
        .DATA_MOUSE_IN(DataMouseIn),
        //Control
        .READ_ENABLE (ReadEnable),
        .BYTE_READ(ByteRead),
        .BYTE_ERROR_CODE(ByteErrorCode),
        .BYTE_READY(ByteReady)
    );
    ///////////////////////////////////////////////////////
    //Instantiate the Master State Machine module
    wire [7:0] MouseStatusRaw;
    wire [7:0] MouseDxRaw;
    wire [7:0] MouseDyRaw;
    wire [3:0] MasterStateCode;
    wire SendInterrupt;
    MouseMasterSM MSM(
        //Standard Inputs
        .RESET(RESET),
        .CLK(CLK),
        //Transmitter Interface
        .SEND_BYTE(SendByteToMouse),
        .BYTE_TO_SEND(ByteToSendToMouse),
        .BYTE_SENT(ByteSentToMouse),
        //Receiver Interface
        .READ_ENABLE (ReadEnable),
        .BYTE_READ(ByteRead),
        .BYTE_ERROR_CODE(ByteErrorCode),
        .BYTE_READY(ByteReady),
        //Data Registers
        .MOUSE_STATUS(MouseStatusRaw),
        .MOUSE_DX(MouseDxRaw),
        .MOUSE_DY(MouseDyRaw),
        .MasterStateCode(MasterStateCode),
        .SEND_INTERRUPT(SendInterrupt)
    );
    //Pre-processing - handling of overflow and signs.
    //More importantly, this keeps tabs on the actual X/Y
    //location of the mouse.
    wire signed [8:0] MouseDx;
    wire signed [8:0] MouseDy;
    wire signed [8:0] MouseNewX;
    wire signed [8:0] MouseNewY;
    //DX and DY are modified to take account of overflow and direction
    assign MouseDx = (MouseStatusRaw[6]) ? (MouseStatusRaw[4] ? {MouseStatusRaw[4],8'h00} :
    {MouseStatusRaw[4],8'hFF} ) : {MouseStatusRaw[4],MouseDxRaw[7:0]};
     // assign the proper expression to MouseDy
    assign MouseDy = (MouseStatusRaw[7]) ? (MouseStatusRaw[5] ? {MouseStatusRaw[5],8'h00} :
     {MouseStatusRaw[5],8'hFF} ) : {MouseStatusRaw[5],MouseDyRaw[7:0]};
     
     reg[8:0] MouseDx_SLOW;
     reg[8:0] MouseDy_SLOW;
     
     always@(posedge CLK)begin
        MouseDx_SLOW <= MouseDx / 2;
        MouseDy_SLOW <= MouseDy / 2;
//          MouseDx_SLOW <= {MouseDx[8],1'b0,MouseDx[7:1]};
//          MouseDy_SLOW <= {MouseDy[8],1'b0,MouseDy[7:1]};
     end
     // calculate new mouse position
//    assign MouseNewX = {1'b0,MouseX} + MouseDx;
//    assign MouseNewY = {1'b0,MouseY} + MouseDy;
    assign MouseNewX = (SENSITIVITY) ? {1'b0,MouseX} + MouseDx_SLOW : {1'b0,MouseX} + MouseDx;
    assign MouseNewY = (SENSITIVITY) ? {1'b0,MouseY} + MouseDy_SLOW : {1'b0,MouseY} + MouseDy;
    always@(posedge CLK) begin
        if(RESET) begin
            MouseStatus <= 0;
            MouseX <= MouseLimitX/2;
            MouseY <= MouseLimitY/2;
        end else if (SendInterrupt) begin
            //Status is stripped of all unnecessary info
            MouseStatus <= MouseStatusRaw[3:0];
            //X is modified based on DX with limits on max and min 
            if(MouseNewX < 0)
                MouseX <= 0;
            else if(MouseNewX > (MouseLimitX-1))
                MouseX <= MouseLimitX-1;
            else
                MouseX <= MouseNewX[7:0];
            //Y is modified based on DY with limits on max and min
            if(MouseNewY < 0)
                MouseY <= 0;
            else if(MouseNewY > (MouseLimitY-1))
                MouseY <= MouseLimitY-1;
            else
                MouseY <= MouseNewY[7:0];
        end
    end
    
    ///////////////////////////////////////////////////////
    //Sending interrupt. 
    reg InterruptReg;
    always@(posedge CLK)begin
        if(RESET)begin
            InterruptReg <= 0;
        end
        else begin                      
            if(SendInterrupt)              
                InterruptReg <= 1;       //when the MSM is in 'send interrupt' state,set the reg high and hold
            else if(MOUSE_INTERRUPTS_ACK)   
                InterruptReg <= 0;
        end
    end
       
    assign  MOUSE_INTERRUPTS_RAISE = InterruptReg;
     
    ///////////////////////////////////////////////////////
    //Bus interface
    reg [7:0] OUT;
    reg OUT_EN;
    always@(posedge CLK)begin
        if(BUS_ADDR[7:4] == MouseBaseAddr[7:4])begin    //address match
            case(BUS_ADDR[3:0])
                4'h0: OUT <= MouseStatus;
                4'h1: OUT <= MouseX;
                4'h2: OUT <= 32'd119 - MouseY;
            endcase
             
            OUT_EN  <= 1'b1;    //Enable data bus output
        end
        else
            OUT_EN  <= 0;       //set data bus as input
    end

endmodule