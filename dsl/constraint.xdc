set_property PACKAGE_PIN W5 [get_ports CLK]
    set_property IOSTANDARD LVCMOS33 [get_ports CLK]
    
set_property PACKAGE_PIN U18 [get_ports RESET]
    set_property IOSTANDARD LVCMOS33 [get_ports RESET]
    
    
    
#IR TRANSMITTER 
set_property PACKAGE_PIN G2 [get_ports IR_LED]
    set_property IOSTANDARD LVCMOS33 [get_ports IR_LED]
    
set_property PACKAGE_PIN V17 [get_ports switch]
    set_property IOSTANDARD LVCMOS33 [get_ports switch]
    #command from push button
    set_property PACKAGE_PIN T18 [get_ports {COMMAND[0]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[0]}]
    set_property PACKAGE_PIN U17 [get_ports {COMMAND[1]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[1]}]   
    set_property PACKAGE_PIN T17 [get_ports {COMMAND[2]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[2]}]   
    set_property PACKAGE_PIN W19 [get_ports {COMMAND[3]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[3]}]


#MOUSE 
set_property PACKAGE_PIN C17 [get_ports CLK_MOUSE]
    set_property IOSTANDARD LVCMOS33 [get_ports CLK_MOUSE]
        set_property PULLUP true [get_ports CLK_MOUSE]

set_property PACKAGE_PIN B17 [get_ports DATA_MOUSE]
    set_property IOSTANDARD LVCMOS33 [get_ports DATA_MOUSE]
        set_property PULLUP true [get_ports DATA_MOUSE]

set_property PACKAGE_PIN T2 [get_ports SENSITIVITY]
    set_property IOSTANDARD LVCMOS33 [get_ports SENSITIVITY]        
    
#VGA

set_property PACKAGE_PIN G19 [get_ports {COLOUR_OUT[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[0]}]
set_property PACKAGE_PIN H19 [get_ports {COLOUR_OUT[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[1]}]
set_property PACKAGE_PIN J19 [get_ports {COLOUR_OUT[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[2]}]
set_property PACKAGE_PIN N19 [get_ports {COLOUR_OUT[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[3]}]



set_property PACKAGE_PIN J17 [get_ports {COLOUR_OUT[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[4]}]
set_property PACKAGE_PIN H17 [get_ports {COLOUR_OUT[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[5]}]
set_property PACKAGE_PIN G17 [get_ports {COLOUR_OUT[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[6]}]
set_property PACKAGE_PIN D17 [get_ports {COLOUR_OUT[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[7]}]



set_property PACKAGE_PIN N18 [get_ports {COLOUR_OUT[8]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[8]}]
set_property PACKAGE_PIN L18 [get_ports {COLOUR_OUT[9]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[9]}]
set_property PACKAGE_PIN K18 [get_ports {COLOUR_OUT[10]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[10]}]
set_property PACKAGE_PIN J18 [get_ports {COLOUR_OUT[11]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[11]}]


set_property PACKAGE_PIN P19 [get_ports HS]
    set_property IOSTANDARD LVCMOS33 [get_ports HS]
set_property PACKAGE_PIN R19 [get_ports VS]
    set_property IOSTANDARD LVCMOS33 [get_ports VS]

set_property PACKAGE_PIN W2  [get_ports {COLOR_BIAS[0]}]                    
set_property IOSTANDARD LVCMOS33 [get_ports {COLOR_BIAS[0]}]
set_property PACKAGE_PIN U1 [get_ports {COLOR_BIAS[1]}]                    
set_property IOSTANDARD LVCMOS33 [get_ports {COLOR_BIAS[1]}]
set_property PACKAGE_PIN T1 [get_ports {COLOR_BIAS[2]}]                    
set_property IOSTANDARD LVCMOS33 [get_ports {COLOR_BIAS[2]}]
set_property PACKAGE_PIN R2 [get_ports {COLOR_BIAS[3]}]                    
set_property IOSTANDARD LVCMOS33 [get_ports {COLOR_BIAS[3]}]

set_property PACKAGE_PIN R3 [get_ports COLOR_SW]                    
set_property IOSTANDARD LVCMOS33 [get_ports COLOR_SW]

